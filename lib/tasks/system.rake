namespace :system do

  namespace :admin_accounts do

    desc "Create an admin account"
    task :create, [:email, :password, :key] => [:environment] do |t,args|
      if args[:key] == ENV['RAKE_TASK_KEY'] && ENV['__ORIGIN__'] == 'admin'
        password = args[:password] || SecureRandom.hex(8)
        admin = AdminAccount.create({
          email: args[:email], 
          password: password
        })
        puts "AdminAccount with email #{admin.email} and password: #{password} successfully created"
      end
    end

  end

  namespace :elasticsearch do

    desc "Import published courses to elasticsearch index"
    task :import_courses, [:key] => [:environment] do |t,args|
      if args[:key] == ENV['RAKE_TASK_KEY'] && ENV['__ORIGIN__'] == 'admin'
        Course.default_import_to_search_index
      end
    end

    desc "Reset courses index"
    task :reset_courses_index, [:key] => [:environment] do |t,args|
      if args[:key] == ENV['RAKE_TASK_KEY'] && ENV['__ORIGIN__'] == 'admin'
        Course.reset_index!
      end
    end

  end

  namespace :scheduler do

    desc "Pull courses from Napoleon"
    task :courses_service, [:global_sequence] => [:environment] do |t, args|
      Integration::Napoleon::CourseService.run(args[:global_sequence])
    end

    desc "Pull tracked actions from all AFNs"
    task tracked_actions_service: [:environment] do |t, args|
      Integration::Awin::TrackedActionService.run
      Integration::ImpactRadius::TrackedActionService.run
      Integration::RakutenMarketing::TrackedActionService.run
    end

    namespace :rakuten_marketing do
      desc "Pull tracked actions from Rakuten Marketing"
      task tracked_actions_service: [:environment] do |t, args|
        Integration::RakutenMarketing::TrackedActionService.run
      end
    end

    namespace :awin do
      desc "Pull tracked actions from Awin"
      task :tracked_actions_service, [:start_date, :end_date] => [:environment] do |t, args|
        start_date  = args[:start_date].nil?  ? Time.now : Time.parse(args[:start_date])
        end_date    = args[:end_date].nil?    ? Time.now : Time.parse(args[:end_date])
        Integration::Awin::TrackedActionService.run(start_date: start_date, end_date: end_date)
      end
    end

    namespace :impact_radius do
      desc "Pull tracked actions from Impact Radius"
      task tracked_actions_service: [:environment] do |t, args|
        Integration::ImpactRadius::TrackedActionService.run
      end
    end

  end

end
