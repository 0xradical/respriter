namespace :app do

  task :create_admin_account, [:email, :password] => [:environment] do |t,args|
    password = args[:password] || SecureRandom.hex(8)
    admin = AdminAccount.create({
      email: args[:email], 
      password: password
    })
    puts "AdminAccount with email #{admin.email} and password: #{password} successfully created"
  end

  namespace :seed do
    task run: :environment do |t, args|
      Benchmark.bm(20) do |bm|
        puts "Migrating database ..."
        bm.report "Migrating database ..." do
          Rake::Task['db:migrate'].execute 
        end

        puts "Creating providers ..."
        bm.report "Creating providers ... " do
          Rake::Task['app:csv:import'].invoke(ENV['PROVIDERS_CSV_URL'],'Provider','slug')
        end

        puts "Importing courses ..."
        begin
          Rake::Task['app:integration:courses'].execute
        rescue; end

        puts "Indexing courses ..."
        bm.report "Indexing courses ... " do
          Course.reset_index!
        end
      end
    end
  end

  namespace :csv do
    task :import, [:url, :class, :key] => [:environment] do |t, args|
      csv_file = open(args[:url])
      data = CSV.parse(csv_file, headers: true, row_sep: :auto, col_sep: ",", skip_blanks: true, encoding: "UTF-8")
      args[:class].split('-').map(&:capitalize).join.constantize.send(:import, 
      data.entries.map(&:to_h), on_duplicate_key_update: { 
        conflict_target: [args[:key]], 
        columns: data.headers - [args[:key]] 
      })
    end
  end

  namespace :integration do
    task :courses do |t, args|
      puts "Courses Integration Service"
      Benchmark.realtime do
        gs = Course.global_sequence
        loop do 
          uri = URI("https://napoleon-the-crawler.herokuapp.com/resources/updates/#{next_page}")
          req = Net::HTTP::Get.new(uri)
          req.basic_auth ENV['NAPOLEON_CRAWLER_BASIC_AUTH_USER'], ENV['NAPOLEON_CRAWLER_BASIC_AUTH_PASS']
          res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(req)
          end
          collection = JSON.parse(res.body)
          break if (collection.empty?)
        end
      end
    end
  end

end
