module Napoleon
  class CrawlingEventProcessor::InvalidCourse < CrawlingEventProcessor
    def process
      warn message
    end

    protected
    def message
      [
        "#070004: Invalid Course Error. Got invalid course at #{url}",
        *Integration::Napoleon::ValidatorHandler.new(errors).errors.map(&:message)
      ].join "\n"
    end

    def url
      crawling_event.data['url']
    end

    def errors
      crawling_event.data['errors']
    end
  end
end
