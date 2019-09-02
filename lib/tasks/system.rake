# Call it like bundle exec rake log_sql db:migrate to log
# output
task :log_sql => :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

namespace :system do

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
