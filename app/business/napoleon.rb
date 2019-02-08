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
            blk.call(resource)
          rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid
            next
          end
        end
        global_sequence = resources.last['global_sequence']
      end
    end

    def log(level, msg, tags=nil)
      @logger.tagged('Napoleon', *tags) { @logger.send(level, msg) }
    end


  end

end
