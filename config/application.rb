require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

# Middlewares
require_relative "../lib/middlewares/locale_router"
require_relative "../lib/middlewares/robots_txt_interceptor"
require_relative "../lib/middlewares/sitemap_xml_interceptor"

# Extensions
require_relative "../lib/elements/elements"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.autoload_paths += [
      "#{Rails.root}/app/business",
      "#{Rails.root}/app/uploaders",
      "#{Rails.root}/app/models/reports",
      "#{Rails.root}/app/services"
    ]

    config.middleware.insert_before(ActionDispatch::Static, RobotsTxtInterceptor)
    config.middleware.insert_before(ActionDispatch::Static, SitemapXmlInterceptor)
    config.middleware.use LocaleRouter

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

    config.action_mailer.default_url_options = { host: 'classpert.com' }

    Elements.configure do |elements_config|
      elements_config.asset_host    = ENV.fetch('ELEMENTS_ASSET_HOST') { 'https://elements.classpert.com' }
      elements_config.asset_version = '1.4.2'
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_record.schema_format = :sql

  end
end
