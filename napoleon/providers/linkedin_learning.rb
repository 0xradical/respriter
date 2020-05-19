require 'pry'
require 'erb'

ROOT              = File.expand_path(File.join(File.dirname(__FILE__),'../'))
LINKEDIN_LEARNING = File.join(ROOT, 'providers', 'linkedin_learning')
SEEDS             = File.join(ROOT, 'db', 'seeds', 'linkedin_learning')
template          = File.read(File.join(LINKEDIN_LEARNING, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(LINKEDIN_LEARNING, path))
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id         = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'
user_agent         = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:65.0) Gecko/20100101 Firefox/65.0'
accept_page_header = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
accept_language    = 'en-US,en;q=0.8,*;q=0.3'
accept_api_header  = 'application/vnd.linkedin.normalized+json'

pricing_url          = 'https://www.linkedin.com/learning/subscription/products?upsellOrderOrigin=trk_default_learning'
search_page_url      = 'https://www.linkedin.com/learning/search?entityType=COURSE&keywords=&sortBy=POPULARITY'
base_referer_api_url = 'https://www.linkedin.com/learning/search?keywords=&sortBy=POPULARITY'
base_api_url         = 'https://www.linkedin.com/learning-api/search?enableSpellCheck=true&q=search&sortBy=POPULARITY&useV2Facets=true'

pricing_fetcher     = sql_safe_parsed_unparsed_code 'pricing_pipeline/fetcher.rb'
search_page_fetcher = sql_safe_parsed_unparsed_code 'pricing_pipeline/search_fetcher.rb'
cartesian_fetcher   = sql_safe_parsed_unparsed_code 'cartesian_pipeline/fetcher.rb'
search_fetcher      = sql_safe_parsed_unparsed_code 'search_pipeline/fetcher.rb'
course_fetcher      = sql_safe_parsed_unparsed_code 'courses_pipeline/fetcher.rb'

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
