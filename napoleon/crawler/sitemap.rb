module Napoleon
  class SitemapCrawler < Napoleon::BaseCrawler
    def self.crawl(**options)
      Dir['./**/sitemap_config.yml'].inject([]) do |data, config_path|
        data.concat self.new(config_path).crawl
        data
      end
    end

    protected
    def urls(&block)
      @config[:sitemap_urls].each do |url|
        body = fetch(url).body
        Nokogiri::XML(body).css('url loc').each do |node|
          url = node.text.strip
          yield url if url.present?
        end
      end
    end
  end
end
