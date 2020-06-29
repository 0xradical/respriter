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
      Integration::TrackedActions::ImpactRadiusService.new(run_id).run
      Integration::TrackedActions::RakutenMarketingService.new(run_id).run
      Integration::TrackedActions::CommissionJunctionService.new(run_id).run
      Integration::TrackedActions::AwinService.new(run_id).run
      Integration::TrackedActions::ShareASaleService.new(run_id).run
    end

    namespace :rakuten_marketing do
      desc 'Pull tracked actions from Rakuten Marketing'
      task tracked_actions_service: %i[environment] do |t, args|
        Integration::TrackedActions::RakutenMarketingService.new.run
      end
    end

    namespace :commission_junction do
      desc 'Pull tracked actions from Commission Junction'
      task :tracked_actions_service, %i[start_date end_date] => %i[environment] do |t, args|
        start_date = args[:start_date].nil? ? Time.now : Time.parse(args[:start_date])
        end_date = args[:end_date].nil? ? Time.now : Time.parse(args[:end_date])
        Integration::TrackedActions::CommissionJunctionService.new.run(start_date: start_date, end_date: end_date)
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

    namespace :share_a_sale do
      desc 'Pull tracked actions from ShareASale'
      task :tracked_actions_service, %i[start_date] => %i[environment] do |t, args|
        start_date = args[:start_date].nil? ? Time.now : Time.parse(args[:start_date])
        Integration::TrackedActions::ShareASaleService.new.run(start_date)
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

    desc 'Populate facebook uid using findmyfbid API'
    task :populate_facebook_uid, %i[sleep_time] => %i[environment] do |t,args|
      OrphanedProfile.where("claimable_public_profiles ->> 'facebook' IS NOT NULL AND claimable_public_profiles -> 'facebook' ->> 'uid' IS NULL").each do |op|
        retries = 0
        begin
          uri = URI.parse("https://findmyfbid.in/apiv1/")

          req = Net::HTTP::Post.new(uri.path)
          req.set_form_data('fburl' => "https:#{op.claimable_public_profiles['facebook']['profile_url']}")
          req['Authorization'] = "Token #{ENV['FIND_MY_FB_ID']}"

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          res = http.request(req)

          uid = JSON.parse(res.body)['code']
          op.claimable_public_profiles['facebook']['uid'] = uid
          op.save
          puts "Orphaned profile #{op.id} saved - #{op.claimable_public_profiles['facebook']['profile_url']} | #{uid}"
        rescue
          sleep(180 + (30 ** retries))
          retries += 1
          retry
        end
        sleep(args[:sleep_time].to_i || 30)
      end
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

  namespace :courses do
    desc 'Identify language and set locale and locale_status'
    task :identify_language, %i[condition batch_size] => %i[environment] do |t, args|
      condition = args.fetch(:condition, 'locale_status IS NULL')
      batch_size = args.fetch(:batch_size, 1000).to_i

      count = 0
      identifier = CourseLanguageIdentifier.new
      Course.where(condition).find_each(batch_size: batch_size) do |course|
        identifier.identify! course
        count += 1
      end
      puts "Updated #{count} courses"
    end

    desc 'Execute :identify_language for all courses with null locale_status'
    task :identify_missing_language, %i[batch_size] => %i[environment] do |t, args|
      batch_size = args.fetch(:batch_size, 1000).to_i
      Rake::Task['system:courses:identify_language'].invoke('locale_status IS NULL', batch_size)
    end

    desc 'Manually override language'
    task :override_locale, %i[condition locale batch_size] => %i[environment] do |t, args|
      condition = args.fetch(:condition, '')
      batch_size = args.fetch(:batch_size, 1000).to_i
      locale_str = args.fetch(:locale, '')
      abort "ERROR: No locale given" if locale_str.empty?
      abort "ERROR: No condition given" if condition.empty?

      locale = Locale.from_string(locale_str)
      abort "ERROR: Invalid locale #{args[:locale]}" if locale.empty?

      count = 0
      identifier = CourseLanguageIdentifier.new
      Course.where(condition).find_each(batch_size: batch_size) do |course|
        identifier.override!(course, locale)
        count += 1
      end
      puts "Updated #{count} courses"
    end

    desc 'Manually add a locale to the robots indexing rules'
    task :add_locale_to_robots_index_rules, %i[condition locale batch_size] => %i[environment] do |t, args|
      condition = args.fetch(:condition, '')
      batch_size = args.fetch(:batch_size, 1000).to_i
      locale = Locale.from_string(args.fetch(:locale))
      abort "ERROR: Invalid locale #{args[:locale]}" if locale.empty?
      abort "ERROR: No condition given" if condition.empty?

      count = 0
      Course.where(condition).find_each(batch_size: batch_size) do |course|
        course.add_ignore_robots_noindex_rule_for! locale
        count += 1
      end
      puts "Updated #{count} courses"
    end

    desc 'Copy the locale attribute to ignore_robots_noindex_rule_for'
    task :add_locale_to_robots_index_rules_from_language, %i[condition batch_size] => %i[environment] do |t, args|
      condition = args.fetch(:condition, "ignore_robots_noindex_rule_for = '{}'")
      batch_size = args.fetch(:batch_size, 1000).to_i

      count = 0
      Course.where.not(locale: nil).where(condition).find_each(batch_size: batch_size) do |course|
        course.add_robots_index_rule_from_language!
        count += 1
      end
      puts "Updated #{count} courses"
    end

    desc 'Determine the canonical subdomain based on the locale'
    task :set_canonical_subdomain_from_language, %i[condition batch_size] => %i[environment] do |t, args|
      condition = args.fetch(:condition, '')
      batch_size = args.fetch(:batch_size, 1000).to_i

      count = 0
      Course.where(condition).find_each(batch_size: batch_size) do |course|
        course.set_canonical_subdomain_from_language!
        count += 1
      end
      puts "Updated #{count} courses"
    end

    desc 'Force a set of courses to be indexed in all locales'
    task :force_robots_index, %i[condition] => %i[environment] do |t, args|
      condition = args.fetch(:condition, '')
      abort "ERROR: No condition given" if condition.empty?

      count = Course.where(condition).update_all(ignore_robots_noindex_rule: true)
      puts "Updated #{count} courses"
    end

    desc 'Force a set of courses to be indexed in all locales from a CSV file with slugs'
    task :force_robots_index_from_csv, %i[file_url] => %i[environment] do |t, args|
      csv_slugs = CSV.new(open(args[:file_url]), encoding: 'utf-8').map(&:first).to_set
      found_ids_slugs = []
      csv_slugs.each_slice(200) do |slugs_slice|
        found_ids_slugs += Course.where(slug: slugs_slice).pluck(:id, :slug)
        found_ids_slugs += SlugHistory.where(slug: slugs_slice).pluck(:course_id, :slug)
      end

      count = 0
      found_ids, found_slugs = found_ids_slugs.then { |fis| [fis.map(&:first).to_set, fis.map(&:last).to_set] }
      found_ids.each_slice(200) do |ids_slice|
        count += Course.where(id: ids_slice).update_all(ignore_robots_noindex_rule: true)
      end
      (csv_slugs - found_slugs).each { |slug| puts "Slug not found: #{slug}" }
      puts "Updated #{count} courses"
    end
  end

  namespace :orphaned_profiles do
    desc "Set ignore_robots_noindex_rule_for based on the instructor's courses"
    task set_ignore_robots_noindex_rule: %i[environment] do |t, args|
      OrphanedProfile.enabled.with_courses.find_each do |op|
        locales = []; op.courses.each do |course|
          break unless course.locale
          locale = Locale.from_pg(course.locale)
          locales << locale.language_only.to_s
          locales << locale.to_s
        end
        locales.uniq.each do |locale|
          op.add_ignore_robots_noindex_rule_for!(locale)
        end
      end
    end
  end
end
