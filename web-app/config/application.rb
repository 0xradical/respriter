# frozen_string_literal: true

require_relative 'boot'

require 'rails'

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'

# Middlewares
require_relative '../lib/middlewares/maintenance_mode'
require_relative '../lib/middlewares/locale_router'
require_relative '../lib/middlewares/robots_txt_interceptor'
require_relative '../lib/middlewares/sitemap_xml_interceptor'

# Webpack Dev Server middleware
require_relative '../config/webpack/middleware'

# Extensions
require_relative '../lib/elements/elements'
require_relative '../lib/uuid'
require_relative '../lib/hypernova_batch_builder'
require_relative '../lib/html_heading_demoter'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.session_store :cookie_store, key: :_app_session, domain: :all

    config.cache_store = :mem_cache_store, (ENV['MEMCACHED_SERVERS'] || '').split(','),
                         {
                           username:             ENV['MEMCACHED_USERNAME'],
                           password:             ENV['MEMCACHED_PASSWORD'],
                           failover:             true,
                           socket_timeout:       1.5,
                           socket_failure_delay: 0.2,
                           down_retry_delay:     60
                         }

    config.load_defaults 5.1

    config.autoload_paths +=
      [
        "#{Rails.root}/app/business",
        "#{Rails.root}/app/constraints",
        "#{Rails.root}/app/uploaders",
        "#{Rails.root}/app/models/reports",
        "#{Rails.root}/app/services"
      ]

    Rack::Attack.enabled = ActiveModel::Type::Boolean.new.cast(
      ENV.fetch('ENABLE_RACK_ATTACK') { Rails.env.production? }
    )

    if ENV['WEBPACK_DEV_SERVER_HOST'].present?
      config.middleware.insert_before 0, Webpack::Middleware, ssl_verify_none: true
    end

    config.middleware.insert_before 0, Rack::Attack
    config.middleware.insert_before ActionDispatch::Static, RobotsTxtInterceptor
    config.middleware.insert_before ActionDispatch::Static, SitemapXmlInterceptor

    config.middleware.use LocaleRouter
    config.middleware.use MaintenanceMode

    config.active_job.queue_adapter = :que

    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    config.i18n.available_locales = %w[en es pt-BR ja de fr]

    config.action_mailer.default_url_options = { protocol: 'https', host: 'classpert.com' }
    config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"

    Elements.configure do |elements_config|
      elements_config.asset_host =
        ENV.fetch('ELEMENTS_ASSET_HOST') do
          'https://elements-prd.classpert.com'
        end
      elements_config.asset_version = '9.1.1'
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
      if controller.is_a? ApplicationController
        env = controller.instance_variable_get('@session_tracker') || {}
        qs = env['query_string']
        ua = env['user_agent']&.map { |_k, v| v }&.join('|')
        ua_raw = env['raw']&.send(:[], 'user_agent')
        ip = env['ip']
        cf_country = env['country']
        session_count = env['session_count']
        accept_lang = env['raw']&.send(:[], 'accept_language')

        custom_payload = {}

        custom_payload['qs'] = qs if qs.present?
        custom_payload['ip'] = ip&.ansi(:yellow) if ip.present?
        custom_payload['ua'] = ua&.ansi(:blue) if ua.present?
        custom_payload['ua_raw'] = ua_raw&.ansi(:blue) if ua_raw.present?
        custom_payload['cf_country'] = cf_country if cf_country.present?
        custom_payload['session_count'] = session_count if session_count.present?
        custom_payload['accept_lang'] = accept_lang if accept_lang.present?
        custom_payload
      end
    end
  end
end
