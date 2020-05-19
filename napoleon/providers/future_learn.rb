require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

ROOT     = File.expand_path(File.join(File.dirname(__FILE__),'../'))
PROVIDER = File.join(ROOT, 'providers', 'future_learn')
SEEDS    = File.join(ROOT, 'db', 'seeds', 'future_learn')
template = File.read(File.join(PROVIDER, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read File.join(PROVIDER, path)
  Unparser.parse code
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Classpert Bot (token:77353301-b743-a12f-9a14-3a96a7b4087f)'

course_fetcher = sql_safe_parsed_unparsed_code 'course/fetcher.rb'
course_creator = sql_safe_parsed_unparsed_code 'course/creator.rb'
feed_demux     = sql_safe_parsed_unparsed_code 'feed/demux.rb'

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
