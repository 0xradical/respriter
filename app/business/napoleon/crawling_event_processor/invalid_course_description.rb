module Napoleon
  class CrawlingEventProcessor::InvalidCourseDescription < CrawlingEventProcessor
    def process
      warn "#070005: Invalid Course Description Error. Got invalid description at #{url}\nLinks, images and raw HTML is not allowed.\nDescription:\n#{description}"
    end

    protected
    def url
      crawling_event.data['url']
    end

    def url
      crawling_event.data['description']
    end
  end
end
