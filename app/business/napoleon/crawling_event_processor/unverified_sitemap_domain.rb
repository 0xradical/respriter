module Napoleon
  class CrawlingEventProcessor::UnverifiedSitemapDomain < CrawlingEventProcessor
    def process
      warn "#070009: Unverified domain on sitemap. Got unverified domain #{domain} at sitemap available at #{url}"
    end

    protected
    def url
      crawling_event.data['url']
    end

    def domain
      crawling_event.data['domain']
    end
  end
end
