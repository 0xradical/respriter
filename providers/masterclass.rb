require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

ROOT        = File.expand_path(File.join(File.dirname(__FILE__),'../'))
MASTERCLASS = File.join(ROOT, 'providers', 'masterclass')
SEEDS       = File.join(ROOT, 'db', 'seeds', 'masterclass')
template    = File.read(File.join(MASTERCLASS, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(MASTERCLASS, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Napoleon Crawler (version: 1.0.0, token:4c3a3c38-cc55-43e8-937b-1703e107c268)'

sitemap_url = 'https://www.masterclass.com/sitemap.xml.gz'

course_fetcher = sql_safe_parsed_unparsed_code 'course/fetcher.rb'
sitemap_demux  = sql_safe_parsed_unparsed_code 'sitemap/demux.rb'

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
