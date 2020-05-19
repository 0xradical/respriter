require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

ROOT             = File.expand_path(File.join(File.dirname(__FILE__),'../'))
GENERIC_PROVIDER = File.join(ROOT, 'providers', 'generic_provider')
SEEDS            = File.join(ROOT, 'db', 'seeds', 'generic_provider')
template         = File.read(File.join(GENERIC_PROVIDER, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read File.join(GENERIC_PROVIDER, path)
  Unparser.parse code
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Napoleon Crawler (version: 1.0.0, token:4c3a3c38-cc55-43e8-937b-1703e107c268)'

course_fetcher         = sql_safe_parsed_unparsed_code 'course/fetcher.rb'
course_creator         = sql_safe_parsed_unparsed_code 'course/creator.rb'
sitemap_fetcher        = sql_safe_parsed_unparsed_code 'sitemap/fetcher.rb'
sitemap_demux          = sql_safe_parsed_unparsed_code 'sitemap/demux.rb'
sitemap_demux_sitemaps = sql_safe_parsed_unparsed_code 'sitemap/demux_sitemaps.rb'


setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
