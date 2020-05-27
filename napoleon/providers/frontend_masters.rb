require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

require 'base64'

ROOT             = File.expand_path(File.join(File.dirname(FILE),'../'))
FRONTEND_MASTERS = File.join(ROOT, 'providers', 'frontend_masters')
SEEDS            = File.join(ROOT, 'db', 'seeds', 'frontend_masters')
template         = File.read(File.join(FRONTEND_MASTERS, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(FRONTEND_MASTERS, path))
  Unparser.parse(code)
  '"' + code.gsub('\', '&&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }