require 'parser/current'
require 'unparser'
require 'pg'
require 'erb'

NAPROOT  = File.expand_path(File.join(File.dirname(__FILE__),'../'))
COURSERA = File.join(NAPROOT, 'providers', 'coursera')
SEEDS    = File.join(NAPROOT, 'db', 'seeds', 'coursera')
template = File.read(File.join(COURSERA, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code     = File.read(File.join(COURSERA, path))
  ast      = Unparser.parse(code)
  unparsed = Unparser.unparse(ast)
  PG::Connection.escape_string(unparsed).inspect
end

dataset_id                  = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent                  = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:62.0) Gecko/20100101 Firefox/62.0'
sitemap_url                 = 'https://www.coursera.org/sitemap~www~courses.xml'
sitemap_fetcher             = sql_safe_parsed_unparsed_code('sitemap_pipeline/fetcher.rb')
course_fetcher              = sql_safe_parsed_unparsed_code('courses_pipeline/fetcher.rb')
price_fetcher               = sql_safe_parsed_unparsed_code('courses_pipeline/price_fetcher.rb')
first_lecture_fetcher       = sql_safe_parsed_unparsed_code('courses_pipeline/first_lecture_fetcher.rb')
video_downloader            = sql_safe_parsed_unparsed_code('courses_pipeline/video_downloader.rb')
setup_sql                   = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }