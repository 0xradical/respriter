require 'csv'
namespace :csv do
  task :import, [:url, :class, :key] => [:environment] do |t, args|
    csv_file = open(args[:url])
    data = CSV.parse(csv_file, headers: true, row_sep: :auto, col_sep: ",", skip_blanks: true, encoding: "UTF-8")
    args[:class].split('-').map(&:capitalize).join.constantize.send(:import, data.entries.map(&:to_h), on_duplicate_key_update: { conflict_target: [args[:key]], columns: data.headers - [args[:key]] })
  end
end
