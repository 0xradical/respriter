module Integration
  module Napoleon
    class CourseService

      class << self

        def run(global_sequence=nil)
          global_sequence = global_sequence || Course.current_global_sequence
          ::Napoleon.client.resources(global_sequence) do |resource|

            Course.new.tap do |course|
              course.id                 = resource['id']
              course.global_sequence    = resource['global_sequence']
              course.name               = resource['content']['course_name']
              course.audio              = resource['content']['audio']
              course.subtitles          = resource['content']['subtitles']
              course.price              = resource['content']['price']
              course.url                = resource['content']['url']
              course.pace               = resource['content']['pace']
              course.level              = Array.wrap(resource['content']['level'])
              course.effort             = resource['content']['effort']
              course.free_content       = resource['content']['free_content']
              course.paid_content       = resource['content']['paid_content']
              course.description        = resource['content']['description']
              course.syllabus           = resource['content']['syllabus']
              course.certificate        = resource['content']['certificate']
              course.offered_by         = resource['content']['offered_by']
              course.video              = resource['content']['video']
              course.category           = resource['content']['category']
              course.tags               = resource['content']['tags']
              course.__source_schema__  = resource
            end.upsert

          end
        end

      end

    end
  end
end

