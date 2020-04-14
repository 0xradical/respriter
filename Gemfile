source 'http://rubygems.org'

ruby '2.6.5'

gem 'rails', '~> 6.0.0'
gem 'webpacker', '~> 4.x'
gem 'pg', '~> 1.1'
gem 'puma', '~> 4.2'
gem 'semantic', '~> 1.6.1'

# ActiveRecord
gem 'activerecord-import', '~> 1.0.4'
gem 'active_record_upsert', '~> 0.9.5'
gem 'fast_jsonapi', '~> 1.5'

# Rack
gem 'rack-cors', '~> 1.0.3'
gem 'http', '~> 4.2.0'

gem 'ejs', '~> 1.1.1'
gem 'execjs', '~> 2.7.0'

# SSR
gem 'vueonrails', '~> 1.x'
gem 'hypernova', '~> 1.4.0'

# Pagination
gem 'kaminari', '~> 1.1.1'

# Damerau-Levenshtein
gem 'damerau-levenshtein', '~> 1.3.2'

# MiniMagick
gem 'mini_magick', '~> 4.9.5'
gem 'carrierwave', '~> 2.0.2'
gem 'carrierwave-aws', '~> 1.4.0'

# Thumbor
gem 'ruby-thumbor', '~> 3.0.0'

# Aws
gem 'aws-sdk-cloudfront', '~> 1.23.0'

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
gem 'browser', '~> 2.6.1'
gem 'user_agent_parser', '~> 2.6.0'
gem 'http-accept', '~> 2.1.1'

# Rucaptcha
gem 'rucaptcha', '~> 2.5.2'

# Authentication
gem 'devise', '~> 4.7.1'
gem 'devise-jwt', '~> 0.5.8'
gem 'omniauth-oauth2', '~> 1.6.0'
gem 'omniauth-linkedin-oauth2', '~> 1.0.0'
gem 'omniauth-facebook', '~> 5.0.0'
gem 'omniauth-github', '~> 1.3.0'
gem 'omniauth-twitter', '~> 1.4.0'

# Background jobs
gem 'que',      git: 'https://github.com/que-rb/que.git', ref: 'c3547'
gem 'que-web'

# Sitemap
gem 'sitemap_generator', '~> 6.0.2'
gem 'robotstxt', '~> 0.5.4'

# Email
gem "valid_email2", '~> 3.1.0'
gem 'inky-rb', '~> 1.3.7.5', require: 'inky'
gem 'premailer-rails', '~> 1.10.3'

# LogRage
gem 'lograge', '~> 0.11.2'

# HTTParty
gem 'httparty', '~> 0.17.1'

# DNS
gem 'dnsruby', '~> 1.61.3'
gem 'public_suffix', '~> 4.0.3'

# Provider API Syntax checkers for Ruby and SQL source code
gem 'parser',  '~> 2.7.0.1', require: 'parser/current'
gem 'pg_query', '~> 1.2.0'
gem 'unparser', '~> 0.4.7'

# JSON Schema
gem 'json_schemer', '~> 0.2.8'

group :production do
  # Exceptions
  gem 'sentry-raven', '~> 2.12.2'
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
  gem 'rubocop', '~> 0.80.1', require: false
end
