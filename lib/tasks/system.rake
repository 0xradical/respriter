# Call it like bundle exec rake log_sql db:migrate to log
# output
task log_sql: :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

namespace :system do
  desc 'Upload file to S3'
  task :upload_to_s3, %i[file] => %i[environment] do |t, args|
    ENV['AWS_REGION'] = ENV['AWS_S3_REGION']
    @s3_connector = Aws::S3::Resource.new
    obj =
      @s3_connector.bucket(ENV['AWS_S3_BUCKET_NAME']).object(
        "system/#{args[:file]}"
      )
    obj.upload_file(Rails.root.join("tmp/#{args[:file]}"))
  end

  namespace :admin_accounts do
    desc 'Create an admin account'
    task :create, %i[email password key] => %i[environment] do |t, args|
      if ENV['__ORIGIN__']
        if args[:key] != ENV['RAKE_TASK_KEY']
          raise SecurityError.new('Key mismatch')
        end
      end
      password = args[:password] || SecureRandom.hex(8)
      admin = AdminAccount.create({ email: args[:email], password: password })
      puts "AdminAccount with email #{admin.email} and password: #{
             password
           } successfully created"
    end
  end

  namespace :elasticsearch do
    desc 'Import published courses to elasticsearch index'
    task :import_courses, %i[key] => %i[environment] do |t, args|
      if ENV['__ORIGIN__']
        if args[:key] != ENV['RAKE_TASK_KEY']
          raise SecurityError.new('Key mismatch')
        end
      end
      Course.default_import_to_search_index
    end

    desc 'Reset courses index'
    task :reset_courses_index, %i[key] => %i[environment] do |t, args|
      if ENV['__ORIGIN__']
        if args[:key] != ENV['RAKE_TASK_KEY']
          raise SecurityError.new('Key mismatch')
        end
      end
      Course.reset_index!
    end
  end

  namespace :scheduler do
    desc 'Pull courses from Napoleon'
    task :courses_service, %i[dataset_sequence] => %i[environment] do |t, args|
      Integration::Napoleon::CourseService.run(
        args[:dataset_sequence] || Course.current_dataset_sequence
      )
    end

    desc 'Pull crawling events from Napoleon'
    task :crawling_events_service,
         %i[dataset_sequence] => %i[environment] do |t, args|
      Integration::Napoleon::CrawlingEventService.run(
        args[:dataset_sequence] || CrawlingEvent.current_sequence
      )
    end

    desc 'Pull tracked actions from all AFNs'
    task tracked_actions_service: %i[environment] do |t, args|
      run_id = SecureRandom.hex(4)
      Integration::TrackedActions::AwinService.new(run_id).run
      Integration::TrackedActions::ImpactRadiusService.new(run_id).run
      Integration::TrackedActions::RakutenMarketingService.new(run_id).run
    end

    namespace :rakuten_marketing do
      desc 'Pull tracked actions from Rakuten Marketing'
      task tracked_actions_service: %i[environment] do |t, args|
        Integration::TrackedActions::RakutenMarketingService.new.run
      end
    end

    namespace :awin do
      desc 'Pull tracked actions from Awin'
      task :tracked_actions_service,
           %i[start_date end_date] => %i[environment] do |t, args|
        start_date =
          args[:start_date].nil? ? Time.now : Time.parse(args[:start_date])
        end_date = args[:end_date].nil? ? Time.now : Time.parse(args[:end_date])
        Integration::TrackedActions::AwinService.new.run(
          start_date: start_date, end_date: end_date
        )
      end
    end

    namespace :impact_radius do
      desc 'Pull tracked actions from Impact Radius'
      task tracked_actions_service: %i[environment] do |t, args|
        Integration::TrackedActions::ImpactRadiusService.new.run
      end
    end
  end

  namespace :db do
    desc 'Update orphaned profiles'
    task :update_orphaned_profiles, %i[url] => %i[environment] do |t, args|
      count, errors = 0, []
      CSV.new(open(args[:url]), headers: :first_row, encoding: 'utf-8').each do |row|

        begin
          op = OrphanedProfile.find_or_initialize_by(id: row['id'])
          op.tap do |p|
            p.name              = row['name'].split(' ').map(&:capitalize).join(' ') unless row['name'].blank?
            p.avatar_url        = row['avatar_url'] unless row['avatar_url'].blank?
            p.long_bio          = row['long_bio']   unless row['long_bio'].blank?
            p.short_bio         = row['short_bio']  unless row['short_bio'].blank?
            p.public_profiles   = Hash[eval(row['public_profiles']).select { |k, v| v.present? }.map { |k,v| binding.pry; [k, "//#{v.force_encoding('utf-8')}"] }] unless row['public_profiles'].blank?
            p.email = row['email'] unless row['email'].blank?
          end

          op.course_ids =
            OrphanedProfile.courses_by_instructor_name(row['name'].gsub("'", ''))
            .map { |c| c['id'] } unless row['name'].blank?

          op.save
          puts "#{count+=1} Profile updated - id: #{op.id} name: #{op.name} slug: #{op.slug}"
        rescue Exception => e
          errors << row['id']
          puts "#{count+=1} Error processing #{row} | #{e.message}"
        end

      end
      puts errors
    end

    desc 'Delete enrollments created by crawlers and spider bots'
    task delete_bot_created_enrollments: %i[environment] do |t, args|
      bots = %w[Googlebot GooglePlusBot SemrushBot bingbot AhrefsBot MJ12bot]
      where_op =
        bots.map do |bot|
          "tracking_data -> 'user_agent' ->> 'browser' ILIKE '#{bot}%'"
        end.join(' OR ')
      ActiveRecord::Base.connection.execute(
        "DELETE FROM enrollments WHERE #{where_op}"
      )
    end

    desc 'Reset courses counter cache'
    task reset_courses_counter_cache: %i[environment] do |t, args|
      Course.find_each(batch_size: 1_500) do |course|
        Course.reset_counters(course.id, :enrollments)
      end
    end
  end

  namespace :error_pages do
    desc 'Create static error pages'
    task write_static: %i[environment] do |t, args|
      output_path = Rails.root.join('public')
      pages = Dir.glob(Rails.root.join('app', 'views', 'error_pages', '*'))
      pages.each do |page|
        output_path = Rails.root.join('public', File.basename(page, '.erb'))
        static =
          ApplicationController.render(
            inline: File.read(page), layout: 'http_status'
          )
        File.open(output_path, 'w+') { |file| file << static }
      end
    end
  end
end
