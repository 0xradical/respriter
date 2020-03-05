pipe_process.data = { payload: pipe_process.accumulator[:payload] }
document = Nokogiri.XML pipe_process.data[:payload]

pipe_process.accumulator =
  document.css('url loc').map(&:text).map(&:strip).find_all do |url|
    pipeline.data[:domains].any? do |domain|
      domain_without_www =
        domain.gsub(/^www\./, '')
      url.match %r{^https?\:\/\/([a-zA-Z\-\_0-9]+\.)*#{domain_without_www}\/}
    end
  end.map { |url| { initial_accumulator: { url: url } } }.uniq

call
