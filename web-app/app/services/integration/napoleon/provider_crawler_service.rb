# frozen_string_literal: true

module Integration
  module Napoleon
    class ProviderCrawlerService
      DEFAULT_CRAWLER_VERSION = '1.1.0'
      attr_reader :provider_crawler
      attr_accessor :error

      def initialize(provider_crawler, version = DEFAULT_CRAWLER_VERSION)
        @provider_crawler = provider_crawler
        @version = @provider_crawler.version || version
      end

      def prepared?
        @provider_crawler.status.to_sym == :active && builder.prepared?
      end

      def prepare
        @provider_crawler.reload

        self.error = nil
        scheduled = @provider_crawler&.scheduled

        stop if prepared?

        @provider_crawler.transaction do
          builder.remove_pipeline_templates
          builder.create_pipeline_templates!
          builder.update_provider_crawler!
        rescue StandardError => e
          self.error = e
          builder.rollback!
          raise ActiveRecord::Rollback
        end

        start if scheduled
      end

      def start!
        raise CrawlerNotReady unless prepared?

        self.error = nil

        unless builder.active_pipeline_execution.present?
          @provider_crawler.transaction do
            builder.create_pipeline_execution!
            @provider_crawler.update! scheduled: true
          rescue StandardError => e
            self.error = e
            raise ActiveRecord::Rollback
          end
        end

        raise error if error
      end

      def start
        start! || true
      rescue StandardError
        false
      end

      def stop!
        raise CrawlerNotReady unless prepared?

        self.error = nil

        if builder.active_pipeline_execution.present?
          @provider_crawler.transaction do
            pipeline_execution = builder.active_pipeline_execution
            if pipeline_execution.present?
              builder.delete_pipeline_execution pipeline_execution[:id]
              @provider_crawler.update! scheduled: false
            end
          rescue StandardError => e
            self.error = e
            raise ActiveRecord::Rollback
          end
        end

        raise error if error
      end

      def stop
        stop! || true
      rescue StandardError
        false
      end

      def cleanup
        builder.cleanup if @provider_crawler.version.present?
      end

      def builder
        @builder ||=
          Integration::Napoleon::CrawlerBuilders[@version].new self, @version
      end

      class CrawlerNotReady < StandardError; end
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
