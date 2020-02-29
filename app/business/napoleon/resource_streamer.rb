module Napoleon
  class ResourceStreamer
    class VersionNotSupported < RuntimeError; end

    attr_reader :fields, :kind, :per_page, :locked_versions, :resource_class

    AUTHORIZATION_HEADER = "Bearer #{ENV.fetch 'NAPOLEON_POSTGREST_JWT'}"

    def initialize(
      fields: nil,
      kind: nil,
      per_page: 50,
      locked_versions: nil,
      resource_class: nil
    )
      @fields, @kind, @per_page, @locked_versions, @resource_class =
        fields, kind, per_page, locked_versions, resource_class

      logger = Logger.new STDOUT
      logger.formatter = Logger::Formatter.new
      @logger = ActiveSupport::TaggedLogging.new logger
    end

    def next_endpoint_url
      "#{ENV.fetch 'NAPOLEON_POSTGREST_URI'}/resource_versions?select=#{
        @fields.join ','
      }&order=dataset_sequence&kind=eq.#{@kind}&dataset_sequence=gt." +
        (@dataset_sequence || 0).to_s
    end

    def resources(dataset_sequence, &block)
      @dataset_sequence, @started_at, @run =
        dataset_sequence, Time.now, SecureRandom.hex(4)
      count, errors, run = 0, 0
      log(
        :info,
        "Pulling #{@kind.pluralize} ...",
        ['BEGIN', "run.#{@run}", "seq.#{@dataset_sequence}".ansi(:blue)]
      )
      start_heartbeat
      loop do
        resources = fetch_payload.map { |payload| resource_class.new payload }

        break if resources.empty?
        resources.each do |resource|
          begin
            check_version!(resource.version) if locked_versions.present?

            block.call(resource)
          rescue VersionNotSupported,
                 ActiveRecord::RecordNotUnique,
                 ActiveRecord::StatementInvalid => e
            errors += 1
            log(
              :error,
              "Fail to process resource: #{e.message}",
              [
                "run.#{@run}",
                "seq.#{@dataset_sequence}".ansi(:blue),
                "err.#{errors}".ansi(:red)
              ]
            )
            log(
              :error,
              '--inspect-- ' + resource.to_s.ansi(:red),
              "err.#{errors}".ansi(:red)
            )
            next
          end
          count += 1
        end

        @dataset_sequence = resources.map(&:dataset_sequence).max
      end
      stop_heartbeat
      log(
        :info,
        'Bye! ' + "Total: #{count} resources".ansi(:yellow) + ' | ' +
          (
            if errors.zero?
              "Errors: #{errors.to_s}".ansi(:green)
            else
              "Errors: #{errors.to_s}".ansi(:red)
            end
          ) +
          ' | ' +
          "Took #{elapsed_time}".ansi(:blue),
        ['END', "run.#{@run}", "seq.#{@dataset_sequence}".ansi(:blue)]
      )
    end

    def fetch_payload
      resources_uri = URI(next_endpoint_url)

      Net::HTTP.start(
        resources_uri.host,
        resources_uri.port,
        use_ssl: resources_uri.scheme == 'https'
      ) do |http|
        request = Net::HTTP::Get.new resources_uri
        request['Authorization'] = AUTHORIZATION_HEADER
        request['Range-Unit'] = 'items'
        request['Range'] = "0-#{@per_page - 1}"

        response = http.request request
        if response.code != '200'
          raise "Something went wrong, got HTTP #{response.code}"
        end

        body =
          if response.header['Content-Encoding'] == 'gzip'
            Zlib::GzipReader.new(StringIO.new(response.body)).read
          else
            response.body
          end

        JSON.parse body
      end
    end

    def elapsed_time
      Time.at((Time.now - @started_at)).utc.strftime('%Hh%Mm%Ss')
    end

    def start_heartbeat
      @exit = false
      @heartbeat =
        Thread.new do
          while !@exit
            sleep(300)
            log(
              :info,
              '...',
              [
                "run.#{@run}",
                "seq.#{@dataset_sequence}".ansi(:blue),
                "heartbeat.#{elapsed_time}".ansi(:yellow)
              ]
            )
          end
        end
      Signal.trap('INT') do
        @exit = true
        exit
      end
    end

    def stop_heartbeat
      @heartbeat.kill
    end

    def log(level, msg, tags = nil)
      @logger.tagged('Napoleon', *tags) { @logger.send(level, msg) }
    end

    def check_version!(v)
      unless locked_versions.map do |ver|
               Semantic::Version.new(v).satisfies?(ver)
             end.reduce(&:|)
        raise VersionNotSupported, "version #{v} not supported"
      end
    end
  end
end
