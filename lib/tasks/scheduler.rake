namespace :app do
  namespace :scheduler do

    task tracked_actions_service: [:environment] do |t, args|
      Integration::Awin::TrackedActionService.run
      Integration::ImpactRadius::TrackedActionService.run
      Integration::RakutenMarketing::TrackedActionService.run
    end

    task courses_service: [:environment] do |t,args|
      Integration::Napoleon::CourseService.run
    end

    namespace :rakuten_marketing do
      task tracked_actions_service: [:environment] do |t, args|
        Integration::RakutenMarketing::TrackedActionService.run
      end
    end

    namespace :awin do
      task :tracked_actions_service, [:start_date, :end_date] => [:environment] do |t, args|
        start_date  = args[:start_date].nil?  ? Time.now : Time.parse(args[:start_date])
        end_date    = args[:end_date].nil?    ? Time.now : Time.parse(args[:end_date])
        Integration::Awin::TrackedActionService.run(start_date: start_date, end_date: end_date)
      end
    end

    namespace :impact_radius do
      task tracked_actions_service: [:environment] do |t, args|
        Integration::ImpactRadius::TrackedActionService.run
      end
    end

  end
end
