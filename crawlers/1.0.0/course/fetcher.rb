token = pipeline.data[:user_agent][:token]

accumulator = pipe_process.accumulator

accumulator[:http]                        ||= Hash.new
accumulator[:http][:headers]              ||= Hash.new
accumulator[:http][:headers][:user_agent]  = "Napoleon Crawler (token: #{token})"
accumulator[:http][:follow_redirects]      = { limit: 100 }

call

accumulator = pipe_process.accumulator
if accumulator[:status] == 'skipped'
  pipe_process.accumulator[:crawling_event] = {
    pipe_process_id: pipe_process.id,
    pipeline_id:     pipeline.id,
    type:            'page_fetch_error',
    url:             initial_accumulator[:url],
    status_code:     accumulator[:status_code],
    timestamp:       Time.now,
    crawler_id:      pipeline.data[:crawler_id]
  }
end
