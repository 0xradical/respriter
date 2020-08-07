# frozen_string_literal: true

require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

ROOT             = File.expand_path(File.join(File.dirname(__FILE__), '../'))
HOTMART          = File.join(ROOT, 'providers', 'hotmart')
SEEDS            = File.join(ROOT, 'db', 'seeds', 'hotmart')
template         = File.read(File.join(HOTMART, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(HOTMART, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:67.0) Gecko/20100101 Firefox/67.0'

sitemap_url = 'https://www.hotmart.com/product/sitemap_index.xml'

sitemap_demux = sql_safe_parsed_unparsed_code 'sitemap/demux.rb'
course_fetcher = sql_safe_parsed_unparsed_code 'course/fetcher.rb'
course_creator = sql_safe_parsed_unparsed_code 'course/creator.rb'

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
