module Napoleon
  class CrawlingEventProcessor::SitemapSummary < CrawlingEventProcessor
    def process
      info "Sitemap Fetch Summary: got #{count_23xx} 2xx/3xx #{'page'.pluralize count_23xx}, #{count_1xx} 1xx #{'page'.pluralize count_1xx}, #{count_4xx} 1xx #{'page'.pluralize count_4xx} and #{count_5xx} 5xx #{'page'.pluralize count_5xx}"
    end

    protected
    def count_23xx
      crawling_event.data['2xx/3xx_count']
    end

    def count_1xx
      crawling_event.data['1xx_count']
    end

    def count_4xx
      crawling_event.data['4xx_count']
    end

    def count_5xx
      crawling_event.data['5xx_count']
    end
  end
end
