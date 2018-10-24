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

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.middleware.insert(0, Rack::ReverseProxy) do
      reverse_proxy_options preserve_host: true
      reverse_proxy /^\/blog(\/.*)$/, 'http://blog.quero.com$1', preserve_host: true
    end

    config.autoload_paths += [
      "#{Rails.root}/app/uploaders"
    ]

    config.action_mailer.default_url_options = { host: 'quero.com' }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
