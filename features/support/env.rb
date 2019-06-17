require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'webmock/cucumber'

include Warden::Test::Helpers
Warden.test_mode!

Capybara.configure do |config|
  config.app_host               = 'http://classpert.com'
  config.server_port            = 3000
  config.server_host            = '0.0.0.0'
  config.default_max_wait_time  = 15
end

Capybara.register_driver :chrome do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.add_argument('--no-sandbox')
  browser_options.add_argument('--headless')
  browser_options.add_argument('--disable-gpu')
  browser_options.add_argument("--lang=#{ENV.fetch('BROWSER_LANGUAGE') { 'en' } }")
  browser_options.add_argument('--remote-debugging-port=9222')
  browser_options.add_argument('--remote-debugging-address=0.0.0.0')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.server             = :puma
Capybara.javascript_driver  = :chrome

# Allow only local requests for Capybara
WebMock.disable_net_connect!({
  allow_localhost: true,
  allow: [
    /#{ENV['ELASTICSEARCH_URL']}/
  ]
})

#ActionController::Base.asset_host = Capybara.app_host
# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

Cucumber::Rails::Database.javascript_strategy = :truncation

World(FactoryBot::Syntax::Methods)
World(ActiveJob::TestHelper)
