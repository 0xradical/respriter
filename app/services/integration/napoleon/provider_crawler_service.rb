module Integration
  module Napoleon
    class ProviderCrawlerService
      attr_reader :provider_crawler
      attr_accessor :error

      def initialize(provider_crawler, version = '0.0.1')
        @provider_crawler, @version = provider_crawler, version
      end

      def prepare
        self.error = nil

        @provider_crawler.transaction do
          begin
            builder.create_pipeline_templates!
            update_provider_crawler!
          rescue StandardError => error
            self.error = error
            builder.rollback!
            raise ActiveRecord::Rollback
          end
        end
      end

      def start
        builder.create_pipeline_execution! unless builder.active_pipeline_execution.present?
      end

      def stop
        pipeline_execution = builder.active_pipeline_execution
        if pipeline_execution.present?
          builder.delete_pipeline_execution pipeline_execution[:id]
        end
      end

      def cleanup
        builder.cleanup if @provider_crawler.version.present?
      end

      def builder
        @builder ||=
          Integration::Napoleon::CrawlerBuilders[@version].new self, @version
      end

      def update_provider_crawler!
        @provider_crawler.version = @version
        @provider_crawler.settings = {
          pipeline_templates: builder.pipeline_templates
        }
        @provider_crawler.save!
      end
    end

    crawlers_dir = File.expand_path(Rails.root.join('crawlers'))
    CrawlerBuilders =
      Dir["#{crawlers_dir}/*"].find_all do |dir|
        File.directory? dir
      end.map do |dir|
        path = "#{dir}/builder.rb"
        version = File.basename dir

        klass = Class.new Integration::Napoleon::CrawlerBuilder
        klass.class_eval File.read(path), path

        [version, klass]
      end.to_h
  end
end
