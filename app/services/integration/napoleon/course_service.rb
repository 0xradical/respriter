module Integration
  module Napoleon
    class CourseService
      attr_reader :napoleon

      def initialize(napoleon)
        @napoleon = napoleon
      end

      def run(dataset_sequence = nil)
        dataset_sequence = dataset_sequence || Course.current_dataset_sequence
        self.napoleon.resources(dataset_sequence) do |resource|
          Course.upsert(
            id:                resource['id'],
            dataset_sequence:  resource['dataset_sequence'],
            name:              resource['content']['course_name'],
            audio:             resource['content']['audio'],
            slug:              resource['content']['slug'],
            subtitles:         resource['content']['subtitles'],
            price:             resource['content']['price'],
            url:               resource['content']['url'],
            pace:              resource['content']['pace'],
            level:             Array.wrap(resource['content']['level']),
            effort:            resource['content']['effort'],
            free_content:      resource['content']['free_content'],
            paid_content:      resource['content']['paid_content'],
            description:       resource['content']['description'],
            syllabus:          resource['content']['syllabus'],
            certificate:       resource['content']['certificate'],
            offered_by:        resource['content']['offered_by'],
            instructors:       resource['content']['instructors'],
            video:             resource['content']['video'],
            category:          resource['content']['category'],
            tags:              resource['content']['tags'],
            published:         resource['content']['published'],
            __source_schema__: resource,
            provider_id:       Provider.find_by(name: resource['content']['provider_name'])&.id
          )

        end
      end

      class << self
        def run(dataset_sequence = nil)
          self.new(::Napoleon.client).run(dataset_sequence)
        end
      end
    end
  end
end

