module Napoleon
  class CrawlingEventProcessor::CourseInternalError < CrawlingEventProcessor
    def process
      warn "#070001: Internal Error. Something wrong happened importing course at #{url}"
    end

    protected
    def url
      crawling_event.data['url']
    end
  end
end
