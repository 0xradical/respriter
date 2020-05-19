require 'parser/current'
require 'unparser'
require 'pg'
require 'erb'

NAPROOT  = File.expand_path(File.join(File.dirname(__FILE__),'../'))
EDX      = File.join(NAPROOT, 'providers', 'edx')
SEEDS    = File.join(NAPROOT, 'db', 'seeds', 'edx')
template = File.read(File.join(EDX, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code     = File.read(File.join(EDX, path))
  ast      = Unparser.parse(code)
  unparsed = Unparser.unparse(ast)
  PG::Connection.escape_string(unparsed).inspect
end

dataset_id                  = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent                  = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:62.0) Gecko/20100101 Firefox/62.0'
root_sitemap_url            = 'https://www.edx.org/sitemap.xml'
root_sitemap_fetcher        = sql_safe_parsed_unparsed_code('sitemap_pipeline/root_fetcher.rb')
sitemap_fetcher             = sql_safe_parsed_unparsed_code('sitemap_pipeline/fetcher.rb')
courses_brancher            = sql_safe_parsed_unparsed_code('courses_branching_pipeline/brancher.rb')
courses_expirer             = sql_safe_parsed_unparsed_code('courses_expirer_pipeline/expirer.rb')
api_courses_parser          = sql_safe_parsed_unparsed_code('api_courses_pipeline/parser.rb')
manual_courses_fetcher      = sql_safe_parsed_unparsed_code('manual_courses_pipeline/fetcher.rb')
manual_courses_data_fetcher = sql_safe_parsed_unparsed_code('manual_courses_pipeline/course_data_fetcher.rb')
setup_sql                   = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }