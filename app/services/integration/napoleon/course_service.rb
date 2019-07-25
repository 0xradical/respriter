module Integration
  module Napoleon
    class CourseService

      class << self

        def run(global_sequence=nil)
          global_sequence = global_sequence || Course.current_global_sequence
          ::Napoleon.client.resources(global_sequence) do |resource|

            Course.upsert(
              id:                resource['id'],
              global_sequence:   resource['global_sequence'],
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
              __source_schema__: resource,
              provider_id:       Provider.find_by(name: resource['content']['provider_name'])&.id
            )

          end
        end

      end

    end
  end
end

