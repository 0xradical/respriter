version, token = pipeline.data[:user_agent].values_at :version, :token

accumulator = pipe_process.accumulator

accumulator[:http]                      ||= Hash.new
accumulator[:http][:headers]            ||= Hash.new
accumulator[:http][:headers][:user_agent] = "Napoleon (url: napoleon.classpert.com/docs/crawler, version: #{version}, token: #{token})"

call

accumulator = pipe_process.accumulator
if accumulator[:status] == 'skipped'
  pipe_process.accumulator[:crawling_event] = {
    pipe_process_id: pipe_process.id,
    pipeline_id:     pipeline.id,
    type:            'page_fetch_error',
    url:             initial_accumulator[:url],
    status_code:     accumulator[:status_code],
    timestamp:       Time.now
  }
end
