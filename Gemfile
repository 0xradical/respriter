source 'http://rubygems.org'

ruby '2.6.5'

gem 'rails', '~> 6.0.0'
gem 'webpacker', '~> 4.x'
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

# Damerau-Levenshtein
gem 'damerau-levenshtein'

# MiniMagick
gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-aws'

# Thumbor
gem 'ruby-thumbor'

# Aws
gem 'aws-sdk-cloudfront'

# Elastic Search
gem 'elasticsearch-model', '~> 6.0.0'
gem 'elasticsearch-rails', '~> 6.0.0'
gem 'elasticsearch-dsl',   '~> 0.1.0'

# AffiliateHub
gem 'affiliate_hub',                    git: 'https://github.com/codextremist/affiliate_hub'
gem 'affiliate_hub_rakuten_marketing',  git: 'https://github.com/codextremist/affiliate_hub_rakuten_marketing'
gem 'affiliate_hub_impact_radius',      git: 'https://github.com/codextremist/affiliate_hub_impact_radius'
gem 'affiliate_hub_awin',               git: 'https://github.com/codextremist/affiliate_hub_awin'

# Browser
gem 'browser'
gem 'user_agent_parser'
gem 'http-accept'

# Rucaptcha
gem 'rucaptcha'

# Authentication
gem 'devise'
gem 'devise-jwt', '~> 0.5.8'
gem 'omniauth-oauth2'
gem 'omniauth-linkedin-oauth2', '~> 1.0.0'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'

# Background jobs
gem 'que',      git: 'https://github.com/que-rb/que.git', ref: 'c3547'
gem 'que-web'

# Sitemap
gem 'sitemap_generator'
gem 'robotstxt'

# Email
gem "valid_email2"
gem 'inky-rb', require: 'inky'
gem 'premailer-rails'

# LogRage
gem 'lograge'

# HTTParty
gem 'httparty'

# DNS
gem 'dnsruby'
gem 'public_suffix', '~> 4.0.3'

# Provider API Syntax checkers for Ruby and SQL source code
gem 'parser',  require: 'parser/current'
gem 'pg_query'
gem 'unparser'

# JSON Schema
gem 'json_schemer'

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
