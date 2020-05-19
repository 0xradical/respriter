document = Nokogiri::XML(pipe_process.accumulator[:payload])
pipe_process.accumulator = document.css('sitemap loc')
  .map(&:text)
  .map(&:strip)
  .map{ |url| { initial_accumulator: { url: URI.encode(url) } } }

call