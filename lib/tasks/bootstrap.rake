require 'benchmark'
namespace :bootstrap do
  task run: :environment do |t, args|
    Benchmark.bm(20) do |bm|
      puts "Migrating database ..."
      bm.report "Migrating database ..." do
        Rake::Task['db:migrate'].execute 
      end

      puts "Creating providers ..."
      bm.report "Creating providers ... " do
        Rake::Task['csv:import'].invoke(ENV['PROVIDERS_CSV_URL'],'Provider','slug')
      end

      puts "Importing courses ..."
      begin
        Rake::Task['integration:import_courses'].execute
      rescue; end

      puts "Indexing courses ..."
      bm.report "Indexing courses ... " do
        Course.reset_index!
      end
    end
  end
end
