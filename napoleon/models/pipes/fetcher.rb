module Pipes
  class Fetcher < Pipe
    def execute(pipe_process, accumulator)
      prepare_options pipe_process, accumulator

      response = fetch_response(pipe_process)
      payload  = extract_payload response
      json_ld  = extract_json_ld payload

      results = {
        payload:          payload,
        json_ld:          json_ld,
        status_code:      response.status,
        request_headers:  response.env.request_headers.to_h,
        response_headers: response.headers.to_h,
        cookie_jar:       http_client.dump_cookie_jar
      }.merge(redirect_metadata(response.env))
        .merge(options.slice(:method, :url, :params))
        .deep_symbolize_keys

      status = handle_status! response.status, pipe_process, results

      [ status, results ]
    end

    protected
    def prepare_options(pipe_process, accumulator)
      params = { cache: { version: default_cache_version(pipe_process) } }.deep_merge options
      options.replace params.deep_merge(options).deep_merge accumulator.deep_symbolize_keys!

      if options[:retry][:enabled] && !options[:cache][:refresh] && pipe_process.retried?
        case options[:retry][:refresh]
        when 'always'
          options[:cache][:refresh] = true
        when 'on_itself'
          options[:cache][:refresh] = pipe_process.retried_at?(pipe_process.process_index) && !pipe_process.retried_after?(pipe_process.process_index)
        when 'not_on_itself'
          options[:cache][:refresh] = !pipe_process.retried_at?(pipe_process.process_index)
        when Array
          options[:cache][:refresh] = pipe_process.retried_at?(*options[:retry][:refresh])
        end
      end
    end

    def default_options
      {
        method: :get,
        params: Hash.new,
        status_map: [
          [ [ 200, 299 ], :pending ]
        ],
        cache: {
          refresh:            false,
          ignore_cached_data: false
        },
        retry: {
          enabled: true,
          refresh: 'always'
        },
        http: {
          headers: {
            user_agent: 'Googlebot/2.1 (+http://www.google.com/bot.html)'
          }
        }
      }
    end

    def default_cache_version(pipe_process)
      [
        pipe_process.pipeline.dataset_id,
        pipe_process.pipeline.pipeline_execution_id
      ].compact.join '-'
    end

    def handle_status!(status_code, pipe_process, results)
      options[:status_map].each do |value_or_range, status|
        return status.to_sym if match_status_code?(value_or_range, status_code)
      end

      if options[:retry][:enabled]
        pipe_process.accumulator = results
        pipe_process.retry! "HTTP fetch failed, got status: #{results[:status_code]}"
      else
        :failed
      end
    end

    def match_status_code?(value_or_range, status_code)
      if value_or_range.is_a?(Array)
        Range.new(*value_or_range).include? status_code
      else
        value_or_range.to_i == status_code.to_i
      end
    end

    def fetch_response(pipe_process)
      http_client.public_send *options.values_at(:method, :url, :params)
    rescue
      if options[:retry][:enabled]
        pipe_process.retry! $!
      else
        raise $!
      end
    end

    def http_client
      @http_client ||= Napoleon::HTTPClient.new( options.slice(:cache, :http) )
    end

    def redirect_metadata(env)
      {
        redirected:      !!env[:redirected],
        redirect_count:  env[:redirect_count] || 0,
        original_url:    env[:original_url] || env.url.to_s,
        current_url:     env.url.to_s,
        redirected_urls: env[:redirected_urls]
      }
    end

    def decompress(body)
      Zlib::GzipReader.new( StringIO.new body ).read
    end

    def extract_payload(response)
      return decompress(response.body) if options[:gzip]

      case response.headers['content-type']
      when 'application/x-gzip'
        decompress response.body
      when 'application/json'
        Oj.load response.body
      else
        response.body
      end
    rescue
      puts "Something Wrong Extracting Payload: #{$!}\n  at [#{options[:method]}] #{options[:url]}"
      puts $!.backtrace
      response.body
    end

    def extract_json_ld(payload)
      return nil unless payload.is_a?(String)

      content = Nokogiri::HTML.fragment(payload)
        .css("script[type='application/ld+json']")
        .map{ |node| Oj.load node.text }

      return nil if content.blank?

      content.deep_symbolize_keys
    rescue
      puts "Error Extracting JSON LD: #{$!}\n  at [#{options[:method]}] #{options[:url]}"
      puts $!.backtrace
      nil
    end
  end
end
