call

xml = Nokogiri::XML(pipe_process.accumulator[:payload]).remove_namespaces!
courses_nodes = xml.xpath("//url/loc/text()")

# pipe_process.accumulator = courses_nodes.map do |url|
#   { initial_accumulator: { url: url.text() } }
# end


pipe_process.accumulator = [
  { initial_accumulator: {"url": "https://www.coursera.org/learn/understandingterror"}},
  { initial_accumulator: {"url": "https://www.coursera.org/learn/ageing"}}]
