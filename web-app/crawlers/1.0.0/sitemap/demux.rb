pipe_process.data = { payload: pipe_process.accumulator[:payload] }
document = Nokogiri.XML pipe_process.data[:payload]

if document.css('url loc').empty? && document.css('sitemapindex sitemap').empty?
  pipe_process.accumulator = {
    crawling_event: {
      pipe_process_id: pipe_process.id,
      pipeline_id:     pipeline.id,
      type:            'malformed_sitemap',
      url:             pipe_process.initial_accumulator[:url],
      timestamp:       Time.now,
      crawler_id:      pipeline.data[:crawler_id]
    }
  }
  raise Pipe::Error.new(:skipped, 'Malformed Sitemap')
end

pipe_process.accumulator =
  document.css('url loc').map(&:text).map(&:strip).find_all do |url|
    pipeline.data[:domains].any? do |domain|
      domain_without_www =
        domain.gsub(/^www\./, '')
      url.match %r{^https?\:\/\/([a-zA-Z\-\_0-9]+\.)*#{domain_without_www}\/}
    end
  end.map { |url| { initial_accumulator: { url: url } } }.uniq

call
