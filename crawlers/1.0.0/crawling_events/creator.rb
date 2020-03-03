crawling_event = pipe_process.accumulator[:crawling_event]

pipe_process.accumulator = {
  kind:      'crawling_event',
  unique_id: Digest::SHA1.hexdigest(crawling_event[:pipe_process_id] || [crawling_event[:type], crawling_event[:pipeline_id]].join('-') ),
  content:   crawling_event,
  relations: Hash.new
}

call
