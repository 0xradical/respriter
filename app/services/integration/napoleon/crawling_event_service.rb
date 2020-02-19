module Integration
  module Napoleon
    class CrawlingEventService
      STREAMER_PARAMS = {
        kind: 'crawling_event',
        locked_versions: [
          '0.0.0', '< 2.0.0'
        ],
        resource_class: ::Napoleon::CrawlingEvent,
        fields: [
          'resource_id',
          'dataset_sequence',
          'last_execution_id',
          'content',
          'created_at',
          'updated_at'
        ]
      }

      def run(sequence = CrawlingEvent.current_sequence)
        ::Napoleon::ResourceStreamer.new(STREAMER_PARAMS).resources(sequence) do |resource|
          CrawlingEvent.create(resource.to_crawling_event).process
        end
      end

      class << self
        def run(sequence = CrawlingEvent.current_sequence)
          self.new.run sequence
        end
      end
    end
  end
end
