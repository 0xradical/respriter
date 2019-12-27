pipe_process.data = {
  payload: pipe_process.accumulator[:payload]
}
document = Nokogiri::XML pipe_process.data[:payload]

pipe_process.accumulator = document.css('url loc')
  .map(&:text)
  .map(&:strip)
  .find_all do |url|
    pipeline.data[:domains].any? do |domain|
      # TODO: Notify user about not verified domains on sitemap
      url.match /^https?\:\/\/([a-zA-Z\-\_0-9]+\.)*#{ domain.gsub(/^www\./, '') }\//
    end
  end
  .map{ |url| { initial_accumulator: { url: url } } }

call
