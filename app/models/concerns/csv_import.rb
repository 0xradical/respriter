require 'csv'

module CSVImport
  extend ActiveSupport::Concern

  module ClassMethods

    def import_from_csv(file, conflict_targets)
      data = CSV.parse(file.read, headers: true)
      data_to_import = data.map { |row| row.to_hash.merge({ 'source' => 'import' }) }
      import data_to_import, validate: false
    end

  end
end
