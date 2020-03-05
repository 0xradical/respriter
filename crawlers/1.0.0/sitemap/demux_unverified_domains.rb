document = Nokogiri.XML pipe_process.data[:payload]

unverified_domains = Set.new

has_verified_domain = lambda do |url|
  pipeline.data[:domains].any? do |domain|
    domain_without_www = domain.gsub(/^www\./, '')
    url.match %r{^https?\:\/\/([a-zA-Z\-\_0-9]+\.)*#{domain_without_www}\/}
  end
end

pipe_process.accumulator =
document.css('url loc').map(&:text).map(&:strip).each do |url|
  unless has_verified_domain.call(url)
    unverified_domains.add url.match(%r{^https?\:\/\/(?<domain>[^\/]+)\/})[:domain]
  end
end

document.css('sitemapindex sitemap').map(&:text).map(&:strip).each do |url|
  unless has_verified_domain.call(url)
    unverified_domains.add url.match(%r{^https?\:\/\/(?<domain>[^\/]+)\/})[:domain]
  end
end

pipe_process.accumulator = unverified_domains.map do |domain|
  {
    pipeline_id: pipeline.data[:crawling_events_pipeline_id],
    initial_accumulator: {
      crawling_event: {
        pipe_process_id: pipe_process.id,
        pipeline_id:     pipeline.id,
        digest:          Digest::SHA1.hexdigest(domain),
        type:            'unverified_sitemap_domain',
        url:             pipe_process.initial_accumulator[:url],
        domain:          domain,
        timestamp:       Time.now,
        crawler_id:      pipeline.data[:crawler_id]
      }
    }
  }
end

call
pipe_process.data = nil
