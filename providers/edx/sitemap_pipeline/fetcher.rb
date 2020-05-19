call

xml           = Nokogiri::XML(pipe_process.accumulator[:payload]).remove_namespaces!
courses_nodes = xml.xpath("//url/loc[starts-with(text(),'https://www.edx.org/course/')]")

pipe_process.accumulator = courses_nodes.select do |course_node|
  course_node.text() =~ Regexp.new(["5c2f636f757273655c2f5b5e5c2f5d2b5c5a"].pack('H*'))
end.map do |course_node|
  { initial_accumulator: { url: course_node.text() } }
end