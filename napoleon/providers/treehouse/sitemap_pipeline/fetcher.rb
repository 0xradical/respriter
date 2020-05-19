# Old method
# Treehouse doesn't separate course and course video urls
# so you have to navigate through thousands of urls
# just to download a couple hundreds courses

# xml           = Nokogiri::XML(pipe_process.accumulator[:payload]).remove_namespaces!
# courses_nodes = xml.xpath("//url[./loc[contains(text(), 'https://teamtreehouse.com/library/')]]")
# courses_rgx   = Regexp.new(["7465616d74726565686f7573655c2e636f6d2f6c6962726172792f5b5e2f5d2b5c5a"].pack('H*'))

# pipe_process.accumulator = courses_nodes.select do |url|
#   url.css('loc text()').text() =~ courses_rgx
# end.map do |url|
#   { initial_accumulator: { url: url.css('loc text()').text() } }
# end

# New Method
# Get courses directly from their library/type:course page
call

document = Nokogiri::HTML(pipe_process.accumulator[:payload])

pipe_process.accumulator = document.css('li.card.course').map do |course_card|
  {
    initial_accumulator: {
      url: 'https://teamtreehouse.com' + course_card.css('.card-box').attribute('href')
    }
  }
end