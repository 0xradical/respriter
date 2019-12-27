document = Nokogiri::XML pipe_process.data[:payload]

entries = document.css('sitemapindex sitemap')
  .map(&:text)
  .map(&:strip)
  .find_all do |url|
    pipeline.data[:domains].any? do |domain|
      # TODO: Notify user about not verified domains on sitemap
      url.match /^https?\:\/\/([a-zA-Z\-\_0-9]+\.)*#{ domain.gsub(/^www\./, '') }\//
    end
  end
  .map do |url|
    {
      pipeline_id:         pipeline.id,
      initial_accumulator: { url: url }
    }
  end

pipe_process.accumulator = {
  schedule: true,
  entries:  entries
}

call
pipe_process.data = nil
