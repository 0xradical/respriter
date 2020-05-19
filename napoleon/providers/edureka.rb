require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

ROOT     = File.expand_path(File.join(File.dirname(__FILE__),'../'))
EDUREKA  = File.join(ROOT, 'providers', 'edureka')
SEEDS    = File.join(ROOT, 'db', 'seeds', 'edureka')
template = File.read(File.join(EDUREKA, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(EDUREKA, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:65.0) Gecko/20100101 Firefox/65.0'

sitemap_url = 'https://www.edureka.co/edureka_sitemap.xml'

sitemap_fetcher = sql_safe_parsed_unparsed_code 'sitemap_pipeline/fetcher.rb'
courses_fetcher = sql_safe_parsed_unparsed_code 'courses_pipeline/fetcher.rb'

proxy_host = ENV['PROXY_HOST']
proxy_user = ENV['PROXY_USER']
proxy_pass = ENV['PROXY_PASS']

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
