def database_exists?
  begin
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError
    false
  else
    true
  end
end

namespace :dev do

  desc "Bootstrap the development environment"
  task bootstrap: [:environment] do |t,args|

    input = ''

    if database_exists?
      loop do
        puts "*** WARNING ***".ansi(:red)
        puts "This process will destroy all your existing data! Proceed anyway? [Y/n]".ansi(:red)
        input = STDIN.gets.chomp.downcase
        break if (input == 'y' || input == 'n')
        puts "unrecognized option: ".ansi(:yellow) + input
      end
    end

    exit(0) if input == 'n'

    root = Rails.root

    if File.exists?(root.join('database.yml.example'))
      puts "Creating database.yml from database.yml.example".ansi(:green)
      system 'cp ./config/database.yml.example database.yml'
    end

    system 'bundle install'
    system 'yarn install'

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke

  end

end

