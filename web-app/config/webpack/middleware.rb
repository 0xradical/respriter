# frozen_string_literal: true

require 'rack/proxy'

module Webpack
  class Middleware < Rack::Proxy
    def initialize(app = nil, opts = {})
      opts[:streaming] = false if Rails.env.test? && !opts.key?(:streaming)
      super
    end

    def dev_server_running?
      ENV['WEBPACK_DEV_SERVER_HOST'].present?
    end

    def perform_request(env)
      if dev_server_running? && env['PATH_INFO'].start_with?(public_output_uri_path)
        env['HTTP_HOST'] = env['HTTP_X_FORWARDED_HOST'] = ENV['WEBPACK_DEV_SERVER_HOST']
        env['HTTP_X_FORWARDED_SERVER'] = ENV['WEBPACK_DEV_SERVER_PUBLIC']
        env['HTTP_PORT'] = env['HTTP_X_FORWARDED_PORT'] = ENV['WEBPACK_DEV_SERVER_PORT']
        env['HTTP_X_FORWARDED_PROTO'] = env['HTTP_X_FORWARDED_SCHEME'] = ENV['WEBPACK_DEV_SERVER_PROTOCOL']
        unless ENV['WEBPACK_DEV_SERVER_PROTOCOL'] == 'https'
          env['HTTPS'] = env['HTTP_X_FORWARDED_SSL'] = 'off'
      end
        env['SCRIPT_NAME'] = ''

        super(env)
      else
        @app.call(env)
      end
    end

    private

    def public_output_uri_path
      URI.join(URI('http://'), '/', ENV['WEBPACK_PUBLIC_OUTPUT_PATH'] || '').path + '/'
    end
  end
end
