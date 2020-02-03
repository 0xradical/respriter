# Call it like bundle exec rake log_sql db:migrate to log
# output
task :log_sql => :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

namespace :system do

  desc "Upload file to S3"
  task :upload_to_s3, [:file] => [:environment] do |t, args|
    ENV['AWS_REGION'] = ENV['AWS_S3_REGION']
    @s3_connector = Aws::S3::Resource.new
    obj = @s3_connector.bucket(ENV['AWS_S3_BUCKET_NAME']).object("system/#{args[:file]}")
    obj.upload_file(Rails.root.join("tmp/#{args[:file]}"))
  end

  namespace :admin_accounts do

    desc "Create an admin account"
    task :create, [:email, :password, :key] => [:environment] do |t,args|
      if ENV['__ORIGIN__']
        raise SecurityError.new("Key mismatch") if args[:key] != ENV['RAKE_TASK_KEY']
      end
      password = args[:password] || SecureRandom.hex(8)
      admin = AdminAccount.create({
        email: args[:email], 
        password: password
      })
      puts "AdminAccount with email #{admin.email} and password: #{password} successfully created"
    end

  end

  namespace :elasticsearch do

    desc "Import published courses to elasticsearch index"
    task :import_courses, [:key] => [:environment] do |t,args|
      if ENV['__ORIGIN__']
        raise SecurityError.new("Key mismatch") if args[:key] != ENV['RAKE_TASK_KEY']
      end
      Course.default_import_to_search_index
    end

    desc "Reset courses index"
    task :reset_courses_index, [:key] => [:environment] do |t,args|
      if ENV['__ORIGIN__']
        raise SecurityError.new("Key mismatch") if args[:key] != ENV['RAKE_TASK_KEY']
      end
      Course.reset_index!
    end

  end

  namespace :scheduler do

    desc "Pull courses from Napoleon"
    task :courses_service, [:global_sequence] => [:environment] do |t, args|
      Integration::Napoleon::CourseService.run(args[:global_sequence])
    end

    desc "Pull tracked actions from all AFNs"
    task tracked_actions_service: [:environment] do |t, args|
      run_id = SecureRandom.hex(4)
      Integration::TrackedActions::AwinService.new(run_id).run
      Integration::TrackedActions::ImpactRadiusService.new(run_id).run
      Integration::TrackedActions::RakutenMarketingService.new(run_id).run
    end

    namespace :rakuten_marketing do
      desc "Pull tracked actions from Rakuten Marketing"
      task tracked_actions_service: [:environment] do |t, args|
        Integration::TrackedActions::RakutenMarketingService.new.run
      end
    end

    namespace :awin do
      desc "Pull tracked actions from Awin"
      task :tracked_actions_service, [:start_date, :end_date] => [:environment] do |t, args|
        start_date  = args[:start_date].nil?  ? Time.now : Time.parse(args[:start_date])
        end_date    = args[:end_date].nil?    ? Time.now : Time.parse(args[:end_date])
        Integration::TrackedActions::AwinService.new.run(start_date: start_date, end_date: end_date)
      end
    end

    namespace :impact_radius do
      desc "Pull tracked actions from Impact Radius"
      task tracked_actions_service: [:environment] do |t, args|
        Integration::TrackedActions::ImpactRadiusService.new.run
      end
    end

  end

  namespace :db do

    desc "Update orphaned profiles"
    task :update_orphaned_profiles, [:url] => [:environment] do |t,args|
      CSV.new(open(args[:url]), :headers => :first_row).each do |row|

        public_profiles = {
          website:            row['personal_website_url'],
          udemy:              row['udemy_profile_url'],
          pluralsight:        row['pluralsight_profile_url'],
          skillshare:         row['skillshare_profile_url'],
          linkedin_learning:  row['linkedin_learning_profile_url'],
          facebook:           row['facebook_url'],
          masterclass:        row['masterclass_url'],
          twitter:            row['twitter_url'],
          linkedin:           row['linkedin_url'],
          youtube:            row['youtube_url'],
          instagram:          row['instagram_url'],
          pinterest:          row['pinterest_url'],
          github:             row['github_url']
        }

        op = OrphanedProfile.find_or_initialize_by(id: row['id'])
        op.tap do |p|
          p.name                  = row['name']
          p.avatar_url            = row['avatar_url']
          p.website               = row['personal_website_url']
          p.long_bio              = row['long_bio']
          p.short_bio             = row['short_bio']
          p.public_profiles       = public_profiles.select { |k,v| v.present? }
          p.email                 = row['email']
        end

        op.course_ids = OrphanedProfile.courses_by_instructor_name(row['name'].gsub("'","")).map { |c| c['id'] }

        op.save

        puts "Profile updated - id: #{op.id} name: #{op.name} slug: #{op.slug}"

      end
    end

    desc "Delete enrollments created by crawlers and spider bots"
    task delete_bot_created_enrollments: [:environment] do |t,args|
      bots = %w(Googlebot GooglePlusBot SemrushBot bingbot AhrefsBot MJ12bot)
      where_op = bots.map { |bot| "tracking_data -> 'user_agent' ->> 'browser' ILIKE '#{bot}%'" }.join(' OR ')
      ActiveRecord::Base.connection.execute("DELETE FROM enrollments WHERE #{where_op}")
    end

    desc "Reset courses counter cache"
    task reset_courses_counter_cache: [:environment] do |t,args|
      Course.find_each(batch_size: 1500) do |course|
        Course.reset_counters(course.id, :enrollments)
      end
    end

  end

  namespace :tags do

    task :set_curated_tags_from_csv, [:url] => [:environment] do |t,args|
      CSV.new(open(args[:url]), :headers => :first_row).each do |row|
        # Uncurated courses
        courses = Course.where("curated_tags = '{}' AND tags @> ARRAY[?]::text[]", [row['provider_tag']])

        # Get root tags (category) from a curated course
        root_tags = Course.select("unnest(curated_tags) as tag").by_tags([row['curated_tag']]).map(&:tag).uniq.select do |tag|
          RootTag.all.map(&:id).include?(tag) 
        end

        if !root_tags.empty?
          tags = [root_tags.first, row['curated_tag']].uniq.join(',')
          courses.update_all("curated_tags = '{#{tags}}'")
          puts "#{row['provider_tag']} tagged with #{tags}"
        end

      end
    end

    task generate_suggestions_csv: [:environment] do |t,args|
      filename  = "tags_suggestions_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      filepath  = Rails.root.join("tmp/#{filename}")

      curated_tags = I18n.backend.send(:translations)[:en][:tags].keys.map(&:to_s)

      CSV.open(filepath, 'wb') do |csv|
        csv << [:provider_tag, :suggested_tags]
        Course.distinct_tags.each do |tag|

          # Normalize the provider tag before comparison
          normalized_tag  = tag.downcase.gsub(" ","_").gsub("-","_")
          max_distance    = normalized_tag.size

          # Calculate Levenshtein distance from provider tag with each curated_tag
          results = Hash[curated_tags.map do |curated_tag|
            [curated_tag, DamerauLevenshtein.distance(normalized_tag, curated_tag, 1, max_distance)]
          end]

          # Get the 6 best candidates
          candidates = results.min_by(6) { |k,v| v }

          if candidates[0][1] > 1
            suggestions = candidates.map { |c| c[0] }.join(' ')
          else
            suggestions = candidates[0][0]
          end

          csv << [tag,suggestions]

        end
      end
      Rake::Task['system:upload_to_s3'].invoke(filename)
    end
  end


  namespace :error_pages do
    desc "Create static error pages"
    task write_static: [:environment] do |t,args|
      output_path = Rails.root.join('public')
      pages = Dir.glob(Rails.root.join('app','views', 'error_pages', '*'))
      pages.each do |page|
        output_path = Rails.root.join('public', File.basename(page,'.erb'))
        static      = ApplicationController.render(inline: File.read(page), layout: 'http_status')
        File.open(output_path, 'w+') do |file|
          file << static
        end
      end
    end
  end

end
