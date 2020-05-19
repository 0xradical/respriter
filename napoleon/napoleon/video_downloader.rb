module Napoleon
  class VideoDownloader
    attr_reader :url_from, :destination_bucket, :destination_key, :options

    def initialize(url_from, destination_bucket, destination_key, options = Hash.new)
      @url_from, @destination_bucket, @destination_key = url_from, destination_bucket, destination_key
      @options = default_options.merge options.symbolize_keys
    end

    def call
      return nil if exists?

      uri = URI(@url_from)
      lazy_buffer = LazyFiberBuffer.new

      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri, @options[:http_headers]

        http.request request do |response|
          lazy_buffer.produce do
            response.read_body do |chunk|
              unless accepted_status?(response)
                raise NotAcceptedStatusError.new(response.code.to_i, "Unexpected HTTP status code #{response.code}")
              end

              # TODO: Think more about cases where we don't have Content-Lenght.
              #       Right now memory is not optimized in those cases.
              unless lazy_buffer.has_size?
                if response.header['Content-Length']
                  lazy_buffer.size = response.header['Content-Length'].to_i
                end
              end

              lazy_buffer.write chunk
              Fiber.yield
            end
          end

          s3_client.put_object bucket: @destination_bucket, key: @destination_key, body: lazy_buffer, metadata: { url_from: @url_from }
          lazy_buffer.close
          @exists = true
        end
      end
    end

    protected
    def accepted_status?(response)
      return @accepted_status if @accepted_status != nil

      options[:accepted_statuses].each do |value_or_range|
        if match_status_code?(value_or_range, response.code.to_i)
          @accepted_status = true
          return @accepted_status
        end
      end

      @accepted_status = false
    end

    def match_status_code?(value_or_range, status_code)
      if value_or_range.is_a?(Array)
        Range.new(*value_or_range).include? status_code
      else
        value_or_range.to_i == status_code.to_i
      end
    end

    def default_options
      {
        http_headers: {
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:62.0) Gecko/20100101 Firefox/62.0'
        }
      }
    end

    def exists?
      return @exists unless @exists.nil?

      object_header = s3_client.head_object bucket: @destination_bucket, key: @destination_key

      @exists = object_header.metadata.present? && object_header.metadata['url_from'] == @url_from
    rescue Aws::S3::Errors::NotFound
      @exists = false
    end

    def s3_client
      @s3_client ||= Aws::S3::Client.new Napoleon.config.aws[:s3].merge(validate_params: false)
    end

    class NotAcceptedStatusError < StandardError
      attr_reader :status_code

      def initialize(status_code, message)
        @status_code = status_code
        super message
      end
    end

    class LazyFiberBuffer
      attr_reader :buffer

      def initialize
        @buffer = IO::Buffer.new
        @tempfile = Tempfile.new 'lazy-fiber-buffer'
        @tempfile.binmode
      end

      def has_size?
        !@size.nil?
      end

      def write(payload)
        @buffer.write payload
        @tempfile.write payload
      end

      def read(length, output_string)
        return @tempfile.read(length, output_string) if @rewinded

        resume until @fiber_finished || @buffer.size >= length

        if @buffer.size > 0
          output_string.replace @buffer.read(length)
        else
          nil
        end
      end

      def close
        @tempfile.close
        @tempfile.delete
      end

      def size=(value)
        @size = value
      end

      def size
        resume until @fiber_finished || has_size?

        if has_size?
          @size
        else
          @size = @buffer.size
        end
      end

      def rewind
        @rewinded = true
        @tempfile.rewind
      end

      def produce(&block)
        @fiber = Fiber.new do
          yield
          @fiber_finished = true
        end
      end

      def resume
        @fiber.resume
      end
    end
  end
end
