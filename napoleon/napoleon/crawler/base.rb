module Napoleon
  class BaseCrawler
    attr_reader :config, :root_path

    def initialize(config_path)
      @config    = YAML.load(File.read config_path).deep_symbolize_keys
      @root_path = File.dirname config_path
      @client    = HTTPClient.new # TODO: Need some config here?
    end

    def crawl
      responses = Array.new
      urls do |url|
        responses << { url: url, response: fetch(url) }
      end
      responses
    end

    # Gets all config paths and crawl each instance
    def self.crawl(**options)
      raise NotImplementedError
    end

    protected
    # Iterate over all urls to be crawled on
    # TODO: Extend it to receive HTTP methods and params
    def urls(&block)
      raise NotImplementedError
    end

    # TODO: Extend it to receive HTTP methods and params
    def fetch(url)
      @client.get url
    end
  end
end
