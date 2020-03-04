module Napoleon
  class CrawlingEventProcessor
    attr_reader :crawling_event

    def initialize(crawling_event)
      @crawling_event = crawling_event
    end

    def process
      raise NotImplementedError
    end

    protected

    [:fatal, :error, :warn, :info, :debug].each do |level|
      define_method level do |message|
        log message, level
      end
    end

    def logger
      return @logger if @logger

      @logger = Logger.new STDOUT
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
      @logger
    end

    def log(message, level = :info)
      self.logger.public_send(
        level,
        {
          id: SecureRandom.uuid,
          ps: { id: crawling_event.execution_id, name: 'crawling-event' },
          payload: message
        }.to_json
      )
    end
  end
end
