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
    config.session_store :cookie_store, key: :_app_session, domain: :all

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
    config.i18n.available_locales = ['en', 'es', 'pt-BR']

    config.action_mailer.default_url_options = { host: 'classpert.com' }
    config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"

    Elements.configure do |elements_config|
      elements_config.asset_host    = ENV.fetch('ELEMENTS_ASSET_HOST') { 'https://elements-prd.classpert.com' }
      elements_config.asset_version = '4.17.1'
    end

    config.action_controller.forgery_protection_origin_check = false
    config.action_controller.per_form_csrf_tokens = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_record.schema_format = :sql

    # LogRage settings
    config.lograge.enabled = ENV.fetch('ENABLE_LOGRAGE') { false }
    config.lograge.custom_payload do |controller|
      if controller.kind_of? ApplicationController

        env = controller.instance_variable_get("@session_tracker") || {}

        qs            = env['query_string']
        ua            = env['user_agent']&.map { |k,v| v }&.join('|')
        ip            = env['ip']
        cf_country    = env['country']
        session_count = env['session_count']
        accept_lang   = env['raw']&.send(:[], 'accept_language')

        custom_payload  = {}

        custom_payload['qs']            = qs                if qs.present?
        custom_payload['ip']            = ip&.ansi(:yellow) if ip.present?
        custom_payload['ua']            = ua&.ansi(:blue)   if ua.present?
        custom_payload['cf_country']    = cf_country        if cf_country.present?
        custom_payload['session_count'] = session_count     if session_count.present?
        custom_payload['accept_lang']   = accept_lang       if accept_lang.present?
        custom_payload

      end
    end

  end
end
