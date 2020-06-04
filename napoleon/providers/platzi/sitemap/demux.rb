document = Nokogiri::XML pipe_process.accumulator[:payload]

pipe_process.accumulator = document.css('url loc')
  .map(&:text)
  .map(&:strip)
  .find_all do |url|
    url.match(/^https\:\/\/platzi.com\/cursos\/[^\/]+\/?$/) # || url.match(/^https\:\/\/courses.platzi.com\/courses\//)
  end
  .map { |url| { initial_accumulator: { url: url } } }

call
