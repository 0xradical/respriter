Rails.application.configure do

  # CORS
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins /.*\.classpert\.com\Z/, /.*\.classpert-staging\.com\Z/
      resource '*', headers: :any, credentials: true, expose: %w(Authorization),
      methods: [:get, :put, :patch, :post, :delete, :options]
    end
  end

  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = false

  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
  # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
  # `config/secrets.yml.key`.
  config.read_encrypted_secrets = true

  config.serve_static_assets = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.action_controller.asset_host = ENV.fetch('ASSET_HOST') { "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" }
  config.action_mailer.asset_host = "https://#{config.action_controller.asset_host}"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = ENV.fetch('LOG_LEVEL') { :info }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  config.action_mailer.deliver_later_queue_name = 'default'
  # config.active_job.queue_name_prefix = "app_#{Rails.env}"
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    host: ENV.fetch('HOST', 'classpert.com')
  }
  config.action_mailer.smtp_settings = {
    address:              ENV['SMTP_ADDRESS'],
    port:                 ENV['SMTP_PORT'],
    domain:               'classpert.com',
    user_name:            ENV['SMTP_USER_NAME'],
    password:             ENV['SMTP_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true
  }

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  if ENV['PRERENDER_SERVICE_URL']
    config.middleware.use Rack::Prerender
  end

  # Sentry settings
  Raven.configure do |sentry_config|
    sentry_config.dsn = ENV['SENTRY_DSN']
    sentry_config.sanitize_fields = config.filter_parameters.map(&:to_s)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
