module Integration
  module Napoleon
    class CourseService
      STREAMER_PARAMS = {
        kind: 'course',
        locked_versions: [
          '0.0.0', '< 2.0.0'
        ],
        resource_class: ::Napoleon::CourseResource,
        fields: [
          'id',
          'resource_id',
          'last_execution_id',
          'sequence',
          'dataset_sequence',
          'content',
          'schema_version'
        ]
      }

      def run(dataset_sequence = Course.current_dataset_sequence)
        ::Napoleon::ResourceStreamer.new(STREAMER_PARAMS).resources(dataset_sequence) do |resource|
          Course.upsert resource.to_course
        end
      end

      class << self
        def run(dataset_sequence = Course.current_dataset_sequence)
          self.new.run dataset_sequence
        end
      end
    end
  end
end
