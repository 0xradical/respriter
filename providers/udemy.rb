require 'parser/current'
require 'unparser'
require 'pry'
require 'erb'

require 'base64'

ROOT     = File.expand_path(File.join(File.dirname(__FILE__),'../'))
UDEMY    = File.join(ROOT, 'providers', 'udemy')
SEEDS    = File.join(ROOT, 'db', 'seeds', 'udemy')
template = File.read(File.join(UDEMY, 'setup.sql.erb'))

def sql_safe_parsed_unparsed_code(path)
  code = File.read(File.join(UDEMY, path))
  Unparser.parse(code)
  '"' + code.gsub('\\', '\&\&').gsub(/\n/, '\n').gsub("'", "''").gsub('"', '\"') + '"'
end

dataset_id = '0e9cdf2c-44e7-11e9-8c55-22000aef2c9b'

sitemap_url = 'https://www.udemy.com/sitemap.xml'

course_list_fetcher = sql_safe_parsed_unparsed_code 'course_list/fetcher.rb'
course_list_demux   = sql_safe_parsed_unparsed_code 'course_list/demux.rb'
course_fetcher      = sql_safe_parsed_unparsed_code 'course/fetcher.rb'
course_builder      = sql_safe_parsed_unparsed_code 'course/builder.rb'

subcategories = [ '3D & Animation', 'Accounting & Bookkeeping', 'Advertising', 'Affiliate Marketing', 'Analytics & Automation', 'Apple', 'Architectural Design', 'Arts & Crafts', 'Beauty & Makeup', 'Branding', 'Business Law', 'Career Development', 'Commercial Photography', 'Communications', 'Compliance', 'Content Marketing', 'Creativity', 'Cryptocurrency & Blockchain', 'Dance', 'Data & Analytics', 'Databases', 'Design Thinking', 'Design Tools', 'Development Tools', 'Dieting', 'Digital Marketing', 'Digital Photography', 'E-Commerce', 'Economics', 'Engineering', 'Entrepreneurship', 'Fashion', 'Finance', 'Finance Cert & Exam Prep', 'Financial Modeling & Analysis', 'Fitness', 'Food & Beverage', 'Game Design', 'Game Development', 'Gaming', 'General Health', 'Google', 'Graphic Design', 'Growth Hacking', 'Happiness', 'Hardware', 'Home Business', 'Home Improvement', 'Human Resources', 'Humanities', 'Industry', 'Influence', 'Instruments', 'Interior Design', 'Investing & Trading', 'IT Certification', 'Language', 'Leadership', 'Management', 'Marketing Fundamentals', 'Math', 'Media', 'Meditation', 'Memory & Study Skills', 'Mental Health', 'Microsoft', 'Mobile Apps', 'Money Management Tools', 'Motivation', 'Music Fundamentals', 'Music Software', 'Music Techniques', 'Network & Security', 'Nutrition', 'Online Education', 'Operating Systems', 'Operations', 'Oracle', 'Other', 'Other Finance & Economics', 'Other Teaching & Academics', 'Parenting & Relationships', 'Personal Brand Building', 'Personal Finance', 'Personal Transformation', 'Pet Care & Training', 'Photography Fundamentals', 'Photography Tools', 'Portraits', 'Product Marketing', 'Production', 'Productivity', 'Programming Languages', 'Project Management', 'Public Relations', 'Real Estate', 'Religion & Spirituality', 'Safety & First Aid', 'Sales', 'SAP', 'Science', 'Search Engine Optimization', 'Self Defense', 'Self Esteem', 'Social Media Marketing', 'Social Science', 'Software Engineering', 'Software Testing', 'Spanish', 'Sports', 'Strategy', 'Stress Management', 'Taxes', 'Teacher Training', 'Test Prep', 'Travel', 'User Experience', 'Video & Mobile Marketing', 'Video Design', 'Vocal', 'Web Design', 'Web Development', 'Yoga' ]

authorization_header = "Basic #{ Base64.encode64("#{ENV['UDEMY_CLIENT_ID']}:#{ENV['UDEMY_SECRET']}").gsub(/\s/, '') }"

setup_sql = ERB.new(template).result(binding)

File.open(File.join(SEEDS, 'setup.sql'), 'w') { |f| f.write(setup_sql) }
