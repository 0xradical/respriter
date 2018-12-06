namespace :integration do

  task :courses, [:sequence] => [:environment] do |t, args|
    ActiveRecord::Base.logger = Logger.new(STDOUT) if Rails.env.development?
    puts "*** Courses Integration Service ***"
    Benchmark.realtime do
      cursor = args[:sequence]&.to_i || Course.current_global_sequence
      Napoleon.client.resources(cursor) do |resource|
        begin
          provider  = Provider.find_by!(name: resource['content']['provider_name'])
          course    = Course.find_by(id: resource['id']) || provider.courses.build(id: resource['id'])

          course.tap do |course|
            course.global_sequence    = resource['global_sequence']
            course.dataset_sequence   = resource['dataset_sequence']
            course.resource_sequence  = resource['resource_sequence']
            course.name               = resource['content']['course_name']
            course.subtitles          = resource['content']['subtitles']
            course.category           = resource['content']['category']
            course.published          = Course.is_language_supported?(resource['content']['audio'])
            course.tags               = resource['content']['tags']
            course.audio              = resource['content']['audio']
            course.slug               = resource['content']['slug']
            course.url                = resource['content']['url']
            course.video_url          = resource['content']['video_url']
            course.video              = resource['content']['video']
            course.description        = resource['content']['description']
            course.price              = resource['content']['price'].to_f
          end
          course.save!

        rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid, ActiveRecord::RecordNotUnique => e
          Napoleon.client.log(:error,"#{e.message}", ["global_sequence #{resource['global_sequence']}", e.class.to_s])
        end
      end
    end
  end

end
