module Integration
  module Napoleon
    class ProviderCrawlerService
      attr_reader :provider_crawler

      def initialize(provider_crawler, version = '0.0.1')
        @provider_crawler, @version = provider_crawler, version
      end

      def call
        @provider_crawler.transaction do
          begin
            builder.create_pipeline_templates!
            builder.create_pipeline_executions!
            update_provider_crawler!
          rescue
            builder.rollback!
            raise ActiveRecord::Rollback
          end
        end
      end

      def cleanup
        if @provider_crawler.version.present?
          builder.cleanup
        end
      end

      def builder
        @builder ||= Integration::Napoleon::CrawlerBuilders[@version].new self, @version
      end

      def update_provider_crawler!
        @provider_crawler.version = @version
        @provider_crawler.settings = {
          pipeline_templates:  builder.pipeline_templates,
          pipeline_executions: builder.pipeline_executions
        }
        @provider_crawler.save!
      end
    end

    crawlers_dir = File.expand_path File.dirname(__FILE__)
    CrawlerBuilders = Dir["#{crawlers_dir}/crawler_builder/*"].find_all do |dir|
      File.directory? dir
    end.map do |dir|
      path    = "#{dir}/builder.rb"
      version = File.basename dir

      klass = Class.new Integration::Napoleon::CrawlerBuilder::Base
      klass.class_eval File.read(path), path

      [ version, klass ]
    end.to_h
  end
end
