module Napoleon
  class CrawlingEventProcessor::SitemapFetchError < CrawlingEventProcessor
    def process
      def process
        warn "#070002: Sitemap Fetch Error. Got HTTP status code #{status_code} at #{url}"
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
end
