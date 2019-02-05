module Integration
  module Napoleon
    class CourseService

      class << self

        def run(global_sequence=nil)
          global_sequence = global_sequence || Course.order(global_sequence: :desc).first.global_sequence
          ::Napoleon.client.resources(global_sequence) do |resource|
            Course.new.tap do |course|
              course.id               = resource['id']
              course.global_sequence  = resource['global_sequence']
              course.name             = resource['content']['course_name']
              course.audio            = resource['content']['audio']
              course.subtitles        = resource['content']['subtitles']
              course.price            = resource['content']['price']
              course.url              = resource['content']['url']
              course.description      = resource['content']['description']
              course.published        = resource['content']['published']
              course.provider_id      = Provider.find_by(name: resource['content']['provider_name'])&.id
              course.video            = resource['content']['video']
              course.category         = resource['content']['category']
              course.tags             = resource['content']['tags']
            end.upsert
          end
        end

      end

    end
  end
end

