require 'hypernova'

class HypernovaPlugin
  # NOTE: If an error happens in here, it won’t be caught.
  def on_error(error, job, jobs_hash)
    Rails.logger.error("[hypernova][error]: #{error}")
  end
end

Hypernova.add_plugin!(HypernovaPlugin.new)

Hypernova.configure do |config|
  config.host = ENV.fetch('HYPERNOVA_HOST') { "127.0.0.1" }
  config.port = ENV.fetch('HYPERNOVA_PORT') { 7777 }
  config.open_timeout = 1
  config.timeout = 2
end
