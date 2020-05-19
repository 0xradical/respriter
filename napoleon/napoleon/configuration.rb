require 'singleton'

module Napoleon
  class Configuration
    include Singleton

    def environment
      @environment ||= ( ENV['ENV'] || ENV['RACK_ENV'] || :development ).to_sym
    end

    def aws
      @aws ||= YAML.load_file('config/aws.yml').deep_symbolize_keys[environment]
    end

    def http_cache_bucket
      @http_cache_bucket ||= ENV['HTTP_CACHE_BUCKET']
    end

    def database
      @database ||= ENV['DATABASE_URL'] || HashWithIndifferentAccess.new(YAML.load_file 'config/database.yml')[environment]
    end

    def refresh_cache
      @refresh_cache ||= ENV['REFRESH_CACHE'].present? && ENV['REFRESH_CACHE'].downcase == 'true'
    end

    def logger
      @logger ||= Logger.new STDERR
    end
  end

  def self.config
    Configuration.instance
  end
end
