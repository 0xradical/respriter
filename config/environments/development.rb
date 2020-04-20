# frozen_string_literal: true

Rails.application.configure do
  config.hosts << /.*\.?app\.clspt/

  # CORS
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins /(?:localhost|lvh\.me):[0-9]{,5}\Z/,
              /.*\.app\.clspt\Z/,
              /.*\.classpert\.com\Z/,
              /.*\.classpert-staging\.com/
      resource '*',
               headers: :any,
               credentials: true,
               expose: %w[Authorization],
               methods: %i[get put patch post delete options]
    end
  end

  # Verifies that versions and hashed value of the package contents in the project's package.json
  # config.webpacker.check_yarn_integrity = false

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local =
    ENV.fetch('CONSIDER_ALL_REQUESTS_LOCAL') { true }

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.serve_static_assets = true

  config.action_mailer.asset_host =
    "http://#{ENV.fetch('WEBPACKER_DEV_SERVER_PUBLIC')}"

  config.active_job.queue_adapter = :que
  config.action_mailer.perform_caching = false
  config.action_mailer.deliver_later_queue_name = 'default'
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: ENV.fetch('MAIL_HOST', 'localhost'), port: ENV.fetch('MAIL_PORT', 3_000)
  }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV.fetch('MAILCATCHER_HOST', 'mailcatcher'),
    port: ENV.fetch('MAILCATCHER_PORT', 1_025)
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  console do
    require 'pry'
    config.console = Pry
  end

  config.action_view.raise_on_missing_translations = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
