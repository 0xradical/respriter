namespace :bootstrap do
  task run: :environment do |t, args|
    puts "Migrating database ..."
    Rake::Task['db:migrate'].execute

    puts "Creating providers ..."
    Rake::Task['csv:import'].invoke(ENV['PROVIDERS_CSV_URL'],'Provider')

    puts "Preparing elasticsearch indexes ..."
    begin
      Course.__elasticsearch__.delete_index!
    rescue; end
      Course.__elasticsearch__.create_index!

    puts "Importing courses ..."
    begin
      Rake::Task['integration:import_courses'].execute
    rescue; end

    puts "Indexing courses ..."
    Course.elasticsearch_import
  end
end
