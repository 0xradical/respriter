require 'hypernova'

class HypernovaPlugin
  # NOTE: If an error happens in here, it won’t be caught.
  def on_error(error, job, jobs_hash)
    Rails.logger.error("[hypernova][error]: #{error}")
  end
end

Hypernova.add_plugin!(HypernovaPlugin.new)

Hypernova.configure do |config|
  config.host = "0.0.0.0"
  config.port = 7777            # The port where the node service is listening
end