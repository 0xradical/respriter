require 'parser/current'
require 'unparser'
require 'erb'

NAPROOT     = File.expand_path(File.join(File.dirname(__FILE__),'../'))
PLURALSIGHT = File.join(NAPROOT, 'providers', 'pluralsight')
SEEDS       = File.join(NAPROOT, 'db', 'seeds', 'pluralsight')
template    = File.read(File.join(PLURALSIGHT, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(PLURALSIGHT, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id          = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent          = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:62.0) Gecko/20100101 Firefox/62.0'
sitemap_url         = 'https://www.pluralsight.com/sitemap.xml'
pricing_url         = 'https://subscriptions-production.pluralsight.com/catalog/api/v1/localized-products'
pricing_fetcher     = sql_safe_parsed_unparsed_code('pricing_pipeline/fetcher.rb')
sitemap_fetcher     = sql_safe_parsed_unparsed_code('sitemap_pipeline/fetcher.rb')
course_fetcher      = sql_safe_parsed_unparsed_code('courses_pipeline/fetcher.rb')
course_clip_fetcher = sql_safe_parsed_unparsed_code('courses_pipeline/clip_fetcher.rb')

proxy_host = ENV['PROXY_HOST']
proxy_user = ENV['PROXY_USER']
proxy_pass = ENV['PROXY_PASS']

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }