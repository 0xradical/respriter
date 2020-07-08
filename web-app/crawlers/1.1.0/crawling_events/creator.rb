crawling_event = pipe_process.accumulator[:crawling_event]

unique_id_source = [
  crawling_event[:type],
  crawling_event[:pipe_process_id],
  crawling_event[:pipeline_id],
  crawling_event[:digest]
].compact.join('-')

pipe_process.accumulator = {
  kind:      'crawling_event',
  unique_id: Digest::SHA1.hexdigest(unique_id_source),
  content:   crawling_event,
  relations: Hash.new
}

call
