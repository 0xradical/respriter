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

    attr_accessor :http

    URI = "https://napoleon-the-crawler.herokuapp.com/resources/updates/%{global_sequence}"

    def initialize
      @http             = HTTP
      logger            = Logger.new(STDOUT)
      logger.formatter  = Logger::Formatter.new
      @logger           = ActiveSupport::TaggedLogging.new(logger)
    end

    def resources(global_sequence, &blk)
      loop do
        resources = JSON.parse(http.get(URI % {global_sequence: global_sequence}).body)
        puts "Fetching global_sequence #{global_sequence}..."
        break if resources.empty?
        resources.each do |resource|
          begin
            check_version!(resource['content']['version'])
            blk.call(resource)
          rescue VersionNotSupported, ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
            log('info', "Fail to process resource #{resource['id']}: #{e.message}", ["gs #{resource['global_sequence']}"])
            next
          end
        end
        global_sequence = resources.last['global_sequence']
      end
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
      ['0.0.0','~> 1.0.0']
    end

  end

end
