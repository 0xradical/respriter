require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

ROOT     = File.expand_path(File.join(File.dirname(__FILE__),'../'))
KHAN     = File.join(ROOT, 'providers', 'khan_academy')
SEEDS    = File.join(ROOT, 'db', 'seeds', 'khan_academy')
template = File.read(File.join(KHAN, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(KHAN, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:67.0) Gecko/20100101 Firefox/67.0'

sitemap_url = 'https://www.khanacademy.org/sitemap.xml'

main_sitemap_demux     = sql_safe_parsed_unparsed_code 'main_sitemap/demux.rb'
course_sitemap_fetcher = sql_safe_parsed_unparsed_code 'course_sitemap/fetcher.rb'
course_sitemap_course  = sql_safe_parsed_unparsed_code 'course_sitemap/course.rb'
chapter_fetcher        = sql_safe_parsed_unparsed_code 'chapter/fetcher.rb'
resource_builder       = sql_safe_parsed_unparsed_code 'resource/builder.rb'

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
