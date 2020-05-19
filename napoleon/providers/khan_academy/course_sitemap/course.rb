call

payload  = pipe_process.accumulator[:payload]
json_ld  = pipe_process.accumulator[:json_ld]
document = Nokogiri::HTML.fragment(payload)
domain   = 'https://www.khanacademy.org'

chapters = document.css('div[data-test-id="lesson-card"]').map do |node|
  next unless node.css('h2 a').present?

  path  = node.css('h2 a').attribute('href').text.strip.match(/\/[^\/]\/[^\/]+$/).pre_match
  title = node.css('h2 a').text.strip
  url   = "#{domain}/sitemaps#{path}/sitemap.xml"
  urls  = node.css('h2').first.parent.next_sibling.css('a').map do |a_node|
    "#{domain}#{a_node.attribute('href').text.strip.gsub(/\?.*$/, '')}"
  end.uniq

  {
    title: title,
    path:  path,
    url:   url,
    urls:  urls
  }
end.compact

pipe_process.data.merge! chapters: chapters

pipe_process.accumulator = chapters.map do |chapter|
  {
    initial_accumulator: {
      url:  chapter[:url],
      data: pipe_process.data.merge(chapter: chapter, json_ld: json_ld)
    }
  }
end
