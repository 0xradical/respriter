source 'http://rubygems.org'
source 'https://rails-assets.org'

ruby '2.6.2'

gem 'rails', '~> 5.2.2'
gem 'webpacker', '>= 4.0.x'
gem 'pg'
gem 'puma'
gem 'semantic'

# ActiveRecord
gem 'activerecord-import'
gem 'active_record_upsert'
gem 'fast_jsonapi'

# Rack
gem 'rack-cors'
gem 'http'

gem 'ejs'
gem 'execjs'

# SSR
gem 'vueonrails', '~> 1.x'
gem 'hypernova'

# Pagination
gem 'kaminari'

# MiniMagick
gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-aws'

# Thumbor
gem 'ruby-thumbor'

# Aws
gem 'aws-sdk-cloudfront'

# Elastic Search
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'elasticsearch-dsl'

# AffiliateHub
gem 'affiliate_hub',                    git: 'https://github.com/codextremist/affiliate_hub'
gem 'affiliate_hub_rakuten_marketing',  git: 'https://github.com/codextremist/affiliate_hub_rakuten_marketing'
gem 'affiliate_hub_impact_radius',      git: 'https://github.com/codextremist/affiliate_hub_impact_radius'
gem 'affiliate_hub_awin',               git: 'https://github.com/codextremist/affiliate_hub_awin'

# Browser
gem 'browser'
gem 'user_agent_parser'
gem 'http-accept'

# Authentication
gem 'devise'
gem 'devise-jwt', '~> 0.5.8'
gem 'omniauth-oauth2'
gem 'omniauth-linkedin-oauth2', '~> 1.0.0'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'

# Redis
gem 'redis-namespace'
gem 'redis-rails'

# Background jobs
gem 'que', '1.0.0.beta3'
gem 'que-web'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'

# Sitemap
gem 'sitemap_generator'

# Email
gem "valid_email2"
gem 'inky-rb', require: 'inky'
gem 'premailer-rails'

# SEO
gem 'prerender_rails'

# LogRage
gem 'lograge'

# HTTParty
gem 'httparty'

group :production do
  # Exceptions
  gem 'sentry-raven'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'fivemat'
  gem 'guard-rspec'
  gem 'rspec-mocks'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'spring'
  gem 'factory_bot'
  gem 'factory_bot_rails'
end

gem 'redis'
