module Napoleon
  class CrawlingEventProcessor::UnverifiedCourseDomain < CrawlingEventProcessor
    def process
      warn "#070008: Unverified URL domain on course. Got unverified URL at #{url}, was given #{given_url} on metadata"
    end

    protected
    def url
      crawling_event.data['url']
    end

    def given_url
      crawling_event.data['given_url']
    end
  end
end
