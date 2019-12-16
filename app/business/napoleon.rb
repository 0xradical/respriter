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

    class VersionNotSupported < RuntimeError; end;

    URI = "https://napoleon-the-crawler.herokuapp.com/resources/updates/%{dataset_sequence}"

    attr_accessor :http

    def initialize
      @http             = HTTP
      logger            = Logger.new(STDOUT)
      logger.formatter  = Logger::Formatter.new
      @logger           = ActiveSupport::TaggedLogging.new(logger)
    end

    def resources(dataset_sequence, &blk)
      @dataset_sequence, @started_at, @run = dataset_sequence, Time.now, SecureRandom.hex(4)
      count, errors, run = 0, 0
      log(:info,  "Pulling courses ...",["BEGIN","run.#{@run}", "seq.#{@dataset_sequence}".ansi(:blue)])
      start_heartbeat
      loop do
        resources = JSON.parse(
          http.get(URI % {dataset_sequence: @dataset_sequence}).body
        ).map do |payload|
          ::Napoleon::Resource.new(payload)
        end

        break if resources.empty?
        resources.each do |resource|
          begin
            check_version!(resource.version)
            blk.call(resource)
          rescue VersionNotSupported, ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
            errors += 1
            log(:error,  "Fail to process resource: #{e.message}", ["run.#{@run}", "seq.#{@dataset_sequence}".ansi(:blue), "err.#{errors}".ansi(:red)])
            log(:error, "--inspect-- " + resource.to_s.ansi(:red), "err.#{errors}".ansi(:red))
            next
          end
          count += 1
        end

        @dataset_sequence = resources.last['dataset_sequence']
      end
      stop_heartbeat
      log(:info, "Bye! " + "Total: #{count} resources".ansi(:yellow) + " | " + (errors.zero? ? "Errors: #{errors.to_s}".ansi(:green) : "Errors: #{errors.to_s}".ansi(:red))+ " | " + "Took #{elapsed_time}".ansi(:blue), ["END","run.#{@run}", "seq.#{@dataset_sequence}".ansi(:blue)])
    end

    def elapsed_time
      Time.at((Time.now - @started_at)).utc.strftime('%Hh%Mm%Ss')
    end

    def start_heartbeat
      @exit = false
      @heartbeat = Thread.new do
        while !@exit do
          sleep(300)
          log(:info,"...", ["run.#{@run}", "seq.#{@dataset_sequence}".ansi(:blue), "heartbeat.#{elapsed_time}".ansi(:yellow)])
        end
      end
      Signal.trap('INT') { @exit = true;  exit }
    end

    def stop_heartbeat
      @heartbeat.kill
    end

    def log(level, msg, tags=nil)
      @logger.tagged('Napoleon', *tags) { @logger.send(level, msg) }
    end

    def check_version!(v)
      raise VersionNotSupported, "version #{v} not supported" unless locked_version.map do |ver|
        Semantic::Version.new(v).satisfies?(ver)
      end.reduce(&:|)
    end

    def locked_version
      ['0.0.0','< 2.0.0']
    end

  end

end
