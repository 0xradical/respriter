module Napoleon
  class CrawlingEventProcessor::MalformedSitemap < CrawlingEventProcessor
    def process
      warn "#070010: Malformed Sitemap at #{url}. Your sitemap does not contain any page url or sitemap url."
    end

    protected
    def url
      crawling_event.data['url']
    end
  end
end
