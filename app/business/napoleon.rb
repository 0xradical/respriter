module Napoleon
  def self.config(&settings)
    @@client = Client.new
    @@client.http = @@client.http.instance_eval(&settings)
    @@client
  end

  def self.client
    @@client
  end

  class Client
    class VersionNotSupported < RuntimeError; end

    SELECT_FIELDS        = 'resource_id,id,last_execution_id,sequence,content,schema_version,provider_id,dataset_sequence'
    ENDPOINT_TEMPLATE    = "#{ENV.fetch 'NAPOLEON_POSTGREST_URI'}/resource_versions?select=#{SELECT_FIELDS}&order=dataset_sequence&kind=eq.course&dataset_sequence=gt."
    AUTHORIZATION_HEADER = "Bearer #{ENV.fetch 'NAPOLEON_POSTGREST_JWT'}"
    RESOURCES_PER_PAGE   = 50

    attr_accessor :http

    def initialize
      @http = HTTP
      logger = Logger.new(STDOUT)
      logger.formatter = Logger::Formatter.new
      @logger = ActiveSupport::TaggedLogging.new(logger)
    end

    def resources(dataset_sequence, &blk)
      @dataset_sequence, @started_at, @run =
        dataset_sequence, Time.now, SecureRandom.hex(4)
      count, errors, run = 0, 0
      log(
        :info,
        'Pulling courses ...',
        ['BEGIN', "run.#{@run}", "seq.#{@dataset_sequence}".ansi(:blue)]
      )
      start_heartbeat
      loop do
        resources = fetch_payload.map do |payload|
          ::Napoleon::Resource.new payload
        end

        break if resources.empty?
        resources.each do |resource|
          begin
            check_version!(resource.version)
            blk.call(resource)
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
      resources_uri = URI(ENDPOINT_TEMPLATE + @dataset_sequence.to_s)

      Net::HTTP.start(
        resources_uri.host,
        resources_uri.port,
        use_ssl: resources_uri.scheme == 'https'
      ) do |http|
        request = Net::HTTP::Get.new resources_uri
        request['Authorization'] = AUTHORIZATION_HEADER
        request['Range-Unit']    = 'items'
        request['Range']         = "0-#{RESOURCES_PER_PAGE-1}"

        response = http.request request
        raise "Something went wrong, got HTTP #{response.code}" if response.code != '200'

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
      unless locked_version.map do |ver|
               Semantic::Version.new(v).satisfies?(ver)
             end.reduce(&:|)
        raise VersionNotSupported, "version #{v} not supported"
      end
    end

    def locked_version
      ['0.0.0', '< 2.0.0']
    end
  end
end
