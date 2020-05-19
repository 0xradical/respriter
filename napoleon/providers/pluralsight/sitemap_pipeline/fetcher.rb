call

xml           = Nokogiri::XML(pipe_process.accumulator[:payload]).remove_namespaces!
courses_nodes = xml.xpath("//url[./loc[contains(text(), 'https://www.pluralsight.com/courses/')]]")

pipe_process.accumulator = courses_nodes.map do |url|
  { initial_accumulator: { url: url.css('loc text()').text() } }
end
