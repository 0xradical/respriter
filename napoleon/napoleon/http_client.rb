require_relative 'http_client/cache_middleware'

module Napoleon
  class HTTPClient
    attr_reader :client, :http_options, :cache_options, :cookie_jar

    def initialize(cache: Hash.new, http: Hash.new)
      @http_options  = default_http_options.deep_merge  http
      @cache_options = default_cache_options.deep_merge cache

      follow_redirects = @http_options.delete :follow_redirects
      follow_redirects = case follow_redirects
      when true
        default_redirect_options
      when false
        false
      when nil
        default_redirect_options
      else
        default_redirect_options.deep_merge(follow_redirects)
      end

      @cookie_jar = HTTP::CookieJar.new
      if cookies = @http_options.delete(:cookies)
        cookies.each do |cookie|
          cookie = HTTP::Cookie.new cookie.deep_symbolize_keys
          @cookie_jar.add cookie
        end
      end

      dont_encode_params = @http_options.delete :dont_encode_params

      @client = Faraday.new(@http_options) do |builder|
        builder.use :cookie_jar, jar: @cookie_jar

        builder.response :cache, @cache_options

        if follow_redirects
          builder.response :follow_redirects, follow_redirects
        end

        builder.use :gzip
        builder.use :instrumentation

        builder.adapter Faraday.default_adapter

        if dont_encode_params
          builder.options.params_encoder = DoNotEncodeParams
        end
      end
    end

    def dump_cookie_jar
      JSON.parse(@cookie_jar.to_json).deep_symbolize_keys
    end

    def cache
      @cache_options[:cache]
    end

    def default_cache_options(**storage_options)
      {
        storage: build_storage,
        refresh: Napoleon.config.refresh_cache
      }
    end

    def default_redirect_options
      {
        callback: proc { |old_env, new_env|
          new_env[:redirected] = true

          new_env[:original_url] ||= old_env.url.to_s

          new_env[:redirected_urls] ||= []
          new_env[:redirected_urls] << old_env.url.to_s

          new_env[:redirect_count] ||= 0
          new_env[:redirect_count] += 1
        }
      }
    end

    def default_http_options
      {
        headers: {
          user_agent: 'Googlebot/2.1 (+http://www.google.com/bot.html)'
        },
        ssl: { verify: false }
      }
    end

    def methods
      super | @client.methods
    end

    def respond_to?(method)
      super(method) || @client.respond_to?(method)
    end

    def inspect
      "#<HTTPClient:#{object_id}>"
    end

    def clear_cache
      @cache_options[:storage].delete_all
    end

    protected
    def method_missing(method, *args, &block)
      return super unless @client.respond_to?(method)
      @client.public_send method, *args, &block
    end

    def build_storage
      storage = Napoleon::Storage.new bucket: Napoleon.config.http_cache_bucket
      storage.logger = Napoleon.config.logger
      storage
    end

    class DoNotEncodeParams
      def self.encode(params)
        return params.keys.first

        buffer = ''
        params.each do |key, value|
          buffer << "#{key}=#{value}&"
        end
        return buffer.chop
      end

      def self.decode(string)
        h = Hash.new
        h[string] = ''
        return h
        string.split('&').map do |str|
          str.split('=')
        end.to_h
      end
    end
  end
end
