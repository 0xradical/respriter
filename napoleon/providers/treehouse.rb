require 'parser/current'
require 'unparser'
require 'pg'
require 'erb'

NAPROOT   = File.expand_path(File.join(File.dirname(__FILE__),'../'))
TREEHOUSE = File.join(NAPROOT, 'providers', 'treehouse')
SEEDS     = File.join(NAPROOT, 'db', 'seeds', 'treehouse')
template  = File.read(File.join(TREEHOUSE, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code     = File.read(File.join(TREEHOUSE, path))
  ast      = Unparser.parse(code)
  unparsed = Unparser.unparse(ast)
  PG::Connection.escape_string(unparsed).inspect
end

dataset_id        = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent        = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:62.0) Gecko/20100101 Firefox/62.0'
sitemap_url       = 'https://teamtreehouse.com/library/type:course'
pricing_url       = 'https://teamtreehouse.com/subscribe/plans'
sitemap_fetcher   = sql_safe_parsed_unparsed_code('sitemap_pipeline/fetcher.rb')
pricing_fetcher   = sql_safe_parsed_unparsed_code('pricing_pipeline/fetcher.rb')
course_fetcher    = sql_safe_parsed_unparsed_code('courses_pipeline/fetcher.rb')
video_url_fetcher = sql_safe_parsed_unparsed_code('courses_pipeline/video_url_fetcher.rb')
video_downloader  = sql_safe_parsed_unparsed_code('courses_pipeline/video_downloader.rb')

proxy_host = ENV['PROXY_HOST']
proxy_user = ENV['PROXY_USER']
proxy_pass = ENV['PROXY_PASS']

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }