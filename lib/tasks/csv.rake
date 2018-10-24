require 'csv'
namespace :csv do
  task :import, [:url, :class] => [:environment] do |t, args|
    csv_file = open(args[:url])
    CSV.parse(csv_file, headers: true, row_sep: :auto, col_sep: ",", skip_blanks: true, encoding: "UTF-8").each do |row|
      args[:class].split('-').map(&:capitalize).join.constantize.send(:create, row.to_hash)
    end
  end
end
