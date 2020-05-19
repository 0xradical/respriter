require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'
require 'json'

ROOT     = File.expand_path(File.join(File.dirname(__FILE__),'../'))
ALISON   = File.join(ROOT, 'providers', 'alison')
SEEDS    = File.join(ROOT, 'db', 'seeds', 'alison')
template = File.read(File.join(ALISON, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(ALISON, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:67.0) Gecko/20100101 Firefox/67.0'

sitemaps = [
  [ 'en',    'https://alison.com/sitemaps/sitemap-courses-en.xml'    ],
  [ 'es',    'https://alison.com/sitemaps/sitemap-courses-es.xml'    ],
  [ 'fr',    'https://alison.com/sitemaps/sitemap-courses-fr.xml'    ],
  [ 'it',    'https://alison.com/sitemaps/sitemap-courses-it.xml'    ],
  [ 'pt-BR', 'https://alison.com/sitemaps/sitemap-courses-pt-BR.xml' ]
]

sitemap_fetcher        = sql_safe_parsed_unparsed_code 'sitemap/fetcher.rb'
sitemap_demux          = sql_safe_parsed_unparsed_code 'sitemap/demux.rb'
course_fetcher         = sql_safe_parsed_unparsed_code 'course/fetcher.rb'
course_content_fetcher = sql_safe_parsed_unparsed_code 'course/content_fetcher.rb'
course_creator         = sql_safe_parsed_unparsed_code 'course/creator.rb'

proxy_host = ENV['PROXY_HOST']
proxy_user = ENV['PROXY_USER']
proxy_pass = ENV['PROXY_PASS']

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
