# frozen_string_literal: true

require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

ROOT             = File.expand_path(File.join(File.dirname(__FILE__), '../'))
FRONTEND_MASTERS = File.join(ROOT, 'providers', 'frontend_masters')
SEEDS            = File.join(ROOT, 'db', 'seeds', 'frontend_masters')
template         = File.read(File.join(FRONTEND_MASTERS, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(FRONTEND_MASTERS, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:67.0) Gecko/20100101 Firefox/67.0'

sitemap_url = 'https://frontendmasters.com/sitemap.xml'
pricing_url = 'https://frontendmasters.com/join/'

sitemap_price_fetcher = sql_safe_parsed_unparsed_code 'sitemap/price_fetcher.rb'
sitemap_demux = sql_safe_parsed_unparsed_code 'sitemap/demux.rb'
course_fetcher = sql_safe_parsed_unparsed_code 'course/fetcher.rb'


setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
