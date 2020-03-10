module Integration
  module Napoleon
    class CrawlingEventService
      STREAMER_PARAMS = {
        kind: 'crawling_event',
        resource_class: ::Napoleon::CrawlingEventResource,
        fields: %w[
          resource_id
          dataset_sequence
          last_execution_id
          content
          created_at
          updated_at
        ]
      }

      def run(sequence = nil)
        sequence = CrawlingEvent.current_sequence if sequence.blank? || sequence == 0
        ::Napoleon::ResourceStreamer.new(STREAMER_PARAMS).resources(
          sequence
        ) do |resource|
          params = resource.to_crawling_event
          ProviderCrawler.find_by(id: params[:provider_crawler_id]) or next
          CrawlingEvent.create!(params).process
        end
      end

      class << self
        def run(sequence = nil)
          self.new.run sequence
        end
      end
    end
  end
end
