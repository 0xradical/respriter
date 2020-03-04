module Napoleon
  class CrawlingEventProcessor::PageFetchError < CrawlingEventProcessor
    def process
      warn "#070003: Page Fetch Error. Got HTTP status code #{status_code} at #{url}"
    end

    protected
    def url
      crawling_event.data['url']
    end

    def status_code
      crawling_event.data['status_code']
    end
  end
end
