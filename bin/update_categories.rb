require_relative '../app'

require 'csv'

CORRECT_CATEGORIES = {
  'physycal-science-and-engineering' => 'physical_science_and_engineering',
  'math-and-logic'                   => 'math_and_logic'
}

CSV.open "db/categories/#{$ARGV[0]}.csv", headers: true, encoding: 'UTF-8' do |csv|
  total = csv.readlines.count
  csv.seek 0
  puts csv.gets.inspect

  pb = ProgressBar.create total: total, format: '%a %B %e at %R'

  until csv.eof?
    begin
      row = csv.gets
      Resource.where("content->>'url' = ?", row['url']).each do |resource|
        content = resource.content
        content[:category] = CORRECT_CATEGORIES.fetch row['category'], row['category']
        content[:tags]     = row['tags'].present? ? Oj.load(row['tags']) : []
        content[:reviewed] = true
        resource.save
      end
    rescue
      puts 'something went wrong'
      puts $!
      puts $!.backtrace
    end
    pb.increment
  end
end
