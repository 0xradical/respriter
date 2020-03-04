module Napoleon
  class CrawlingEventProcessor::MultipleCoursesOnPage < CrawlingEventProcessor
    def process
      warn "#070007: Multiple Courses on Page at #{url}"
    end

    protected
    def url
      crawling_event.data['url']
    end
  end
end
