module Napoleon
  class CacheMiddleware
    def initialize(app, options = Hash.new)
      @app, @options = app, options
      @options[:prefix] ||= :page_cache
    end

    def call(env)
      metadata_key = build_metadata_key env

      cached_metadata = storage.fetch metadata_key
      if cached_metadata && !@options[:ignore_cached_data]
        update_env env, cached_metadata
      end

      env_key    = build_env_key env
      cached_env = storage.fetch env_key

      return cached_response(cached_env, env) if cached_env && !refresh?

      perform_request env, env_key, metadata_key, cached_env, cached_metadata
    end

    protected
    def perform_request(env, env_key, metadata_key, cached_env, cached_metadata)
      @app.call(env).on_complete do |response_env|
        if response_env[:status] == 304
          unless cached_env
            # TODO: It's possible to reach this snippet? Maybe...
            storage.copy cached_metadata[:env_key], env_key
            cached_env = storage.fetch cached_metadata[:env_key]
          end

          return cached_response(cached_env, env)
        end

        metadata = build_metadata env, env_key
        storage.write metadata_key, metadata

        cache_data = build_cache_data response_env
        storage.write env_key, cache_data
        response_env
      end
    end

    def cached_response(cached_env, env)
      params  = cached_env.merge request_headers: env.request_headers.to_h
      new_env = Faraday::Env.from params
      Faraday::Response.new new_env
    end

    def build_cache_data(env)
      {
        status:           env.status,
        response_headers: env.response_headers,
        request_headers:  env.request_headers,
        body:             env.body
      }
    end

    def update_env(env, cached_metadata)
      if cached_metadata[:etag]
        env[:request_headers]['If-None-Match'] = cached_metadata[:etag]
      else
        env[:request_headers]['If-Modified-Since'] = cached_metadata[:modified_at] if cached_metadata[:modified_at]
      end
    end

    def build_metadata(env, env_key)
      {
        env_key:     env_key,
        etag:        env.response.headers[:etag],
        modified_at: ( env.response.headers[:last_modified] || Time.now.httpdate )
      }
    end

    def build_env_key(env)
      build_cache_key env, :env, @options[:version]
    end

    def build_metadata_key(env)
      build_cache_key env, :metadata
    end

    def build_cache_key(env, *data)
      # TODO: Think about body params properly
      http_key = [ env[:method], env[:url], env[:body], *data ].compact.map(&:to_s).join '::'
      [ @options[:prefix], Digest::SHA1.hexdigest(http_key) ].compact.join '_'
    end

    def storage
      @options[:storage]
    end

    def refresh?
      @options[:refresh]
    end
  end
end

Faraday::Response.register_middleware cache: lambda{ Napoleon::CacheMiddleware }
