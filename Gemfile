source 'http://rubygems.org'
source 'https://rails-assets.org'

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'webpacker', github: 'rails/webpacker'
gem 'pg'
gem 'puma'
gem 'semantic'

# ActiveRecord
gem 'activerecord-import'
gem 'active_record_upsert'
gem 'fast_jsonapi'

# Rack
gem 'rack-cors'
gem 'rack-reverse-proxy', :require => 'rack/reverse_proxy'
gem 'http'

gem 'ejs'
gem 'execjs'

# Pagination
gem 'kaminari'

# MiniMagick
gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-aws'

# Aws
gem 'aws-sdk', '~> 3'

# Elastic Search
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'elasticsearch-dsl'

# AffiliateHub
gem 'affiliate_hub',                    github: 'codextremist/affiliate_hub'
gem 'affiliate_hub_rakuten_marketing',  github: 'codextremist/affiliate_hub_rakuten_marketing'
gem 'affiliate_hub_impact_radius',      github: 'codextremist/affiliate_hub_impact_radius'
gem 'affiliate_hub_awin',               github: 'codextremist/affiliate_hub_awin'

# Exceptions
gem 'rollbar'

# Browser
gem 'browser'
gem 'user_agent_parser'

# Authentication
gem 'devise'
gem 'devise-jwt', '~> 0.5.8'
gem 'omniauth-oauth2'
#gem 'omniauth'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'

gem 'redis-namespace'
gem 'redis-rails'

# Background jobs
gem 'sidekiq'
gem 'sidekiq-unique-jobs'

# Sitemap
gem 'sitemap_generator'

# Email
gem "valid_email2"

group :test do
  gem 'cucumber-rails', require: false
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'webmock'
  gem 'capybara'
  gem 'selenium-webdriver'
  #gem 'chromedriver-helper'
  gem 'vcr'
  gem 'database_cleaner'
  gem 'fivemat'
  gem 'rspec-its'
  gem 'rspec-mocks'
  gem 'shoulda'
  gem 'timecop'
  gem 'capybara-email'
end

group :development, :test do
  gem 'pry'
  gem 'rack-proxy'
  gem 'foreman'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'spring'
  gem 'listen'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end
