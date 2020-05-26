module Integration
  module TrackedActions
    class BaseService

      def initialize(run_id=SecureRandom.hex(4))
        @run_id           = run_id
        logger            = Logger.new(STDOUT)
        logger.formatter  = Logger::Formatter.new
        @logger           = ActiveSupport::TaggedLogging.new(logger)
      end

      def log(level, msg, tags=nil)
        @logger.tagged('TrackedActionService', *tags) { @logger.send(level, msg) }
      end

    end
  end
end
