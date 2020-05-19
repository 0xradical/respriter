source 'https://rubygems.org'

ruby '2.5.3'

# API
gem 'sinatra',              require: 'sinatra/base'
gem 'sinatra-contrib',      require: 'sinatra/contrib/all'
gem 'sinatra-activerecord', require: 'sinatra/activerecord'

# Web Server
gem 'puma'
gem 'rack'
gem 'rack-proxy'
gem 'rack-contrib'
gem 'rack-utf8_sanitizer'

# HTTP Client
gem 'jwt'
gem 'faraday'
gem 'faraday_middleware'
gem 'faraday-cookie_jar'

# Parser
gem 'nokogiri'
gem 'esprima'
gem 'redcarpet'
gem 'reverse_markdown'
gem 'ruby-duration', require: 'duration'
gem 'json-ld',       require: 'json/ld'
gem 'oj'

# Storage
gem 'pg'
gem 'iobuffer'
gem 'activerecord'
gem 'activerecord-import'

# Mail
gem 'mail'

# AWS
gem 'aws-sdk-s3'
gem 'aws-sdk-cloudfront'

# Background Processing
gem 'que', '1.0.0.beta3'
gem 'que-web'

# Algorithms
gem 'algorithms'

# Misc
gem 'pry'
gem 'i18n'
gem 'rake'
gem 'zlib'
gem 'colorize'
gem 'awesome_print'
gem 'ruby-progressbar'
gem 'json-schema'

# JSON Schema
gem 'json_schemer'

# JS Environment
gem 'therubyracer'

group :test do
  gem 'timecop'
  gem 'json_spec'
  gem 'rack-test'
  gem 'database_cleaner'

  gem 'fivemat'
  gem 'rspec-its'
  gem 'rspec-mocks'
  gem 'shoulda-matchers'
  gem 'rspec-collection_matchers'
end

group :test, :development do
  gem 'rspec'
  gem 'cucumber'
  gem 'webmock'

  gem 'faker'
  gem 'cpf_faker'

  gem 'clipboard'
  gem 'ruby-prof'
  gem 'factory_bot'

  gem 'parser',   require: false
  gem 'unparser', require: false
end
