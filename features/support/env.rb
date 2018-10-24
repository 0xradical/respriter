require 'capybara/poltergeist'
require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'webmock/cucumber'

include Warden::Test::Helpers
Warden.test_mode!

POLTERGEIST_DRIVER_BASE_SETTINGS = {
  js_errors: false,
  timeout: 10,
  phantomjs_options: ['--debug=no', '--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1']
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, POLTERGEIST_DRIVER_BASE_SETTINGS.merge({ phantomjs_logger: Logger.new("/dev/null") }))
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, POLTERGEIST_DRIVER_BASE_SETTINGS.merge({ inspector: true }))
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome,
    url: "http://#{ENV['SELENIUM_HOST']}/wd/hub"
  )
end

Capybara.default_driver    = ENV['CAPYBARA_DEFAULT_DRIVER'].blank? ? :poltergeist : ENV['CAPYBARA_DEFAULT_DRIVER'].try(:to_sym)
Capybara.javascript_driver = ENV['CAPYBARA_JAVASCRIPT_DRIVER'].blank? ? :poltergeist : ENV['CAPYBARA_JAVASCRIPT_DRIVER'].try(:to_sym)

if Capybara.default_driver.to_s.include?('selenium')
  capybara_app_host = %x(/sbin/ip route|awk '/default/ { print $3 }').strip
end

Capybara.configure do |config|
  config.server_port            = ENV['CAPYBARA_SERVER_PORT'] || 3001
  config.server_host            = '0.0.0.0'
  config.app_host               = "http://#{capybara_app_host}:#{config.server_port}" if capybara_app_host
  config.default_max_wait_time  = ENV['CAPYBARA_DEFAULT_MAX_WAIT_TIME'].to_i || 90
end

# Allow only local requests for Capybara
WebMock.disable_net_connect!({
  allow_localhost: true,
  allow: [
    /#{ENV['ELASTICSEARCH_URL']}/,
    /#{ENV['SELENIUM_HOST']}\/wd\/hub/,
    /#{capybara_app_host}/
  ]
})

ActionController::Base.asset_host = Capybara.app_host
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
