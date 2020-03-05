document = Nokogiri.XML pipe_process.data[:payload]

entries =
  document.css('sitemapindex sitemap').map(&:text).map(&:strip).find_all do |url|
    pipeline.data[:domains].any? do |domain|
      domain_without_www =
        domain.gsub(/^www\./, '')
      url.match %r{^https?\:\/\/([a-zA-Z\-\_0-9]+\.)*#{domain_without_www}\/}
    end
  end.map do |url|
    { pipeline_id: pipeline.id, initial_accumulator: { url: url } }
  end

pipe_process.accumulator = { schedule: true, entries: entries.uniq }

call
