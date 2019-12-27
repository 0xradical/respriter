version, token = pipeline.data[:user_agent].values_at :version, :token

accumulator = pipe_process.accumulator

accumulator[:http]                      ||= Hash.new
accumulator[:http][:headers]            ||= Hash.new
accumulator[:http][:headers][:user_agent] = "Napoleon (url: napoleon.classpert.com/docs/crawler, version: #{version}, token: #{token})"

call
