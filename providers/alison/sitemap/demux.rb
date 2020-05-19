document = Nokogiri::XML(pipe_process.accumulator[:payload])
pipe_process.accumulator = document.css('url').map do |url_node|
  {
    initial_accumulator: {
      url:           url_node.css('loc').text.strip,
      language:      pipe_process.data[:language],
      image_url:     url_node.css('image|loc',     image: 'http://www.google.com/schemas/sitemap-image/1.1').text.strip,
      image_caption: url_node.css('image|caption', image: 'http://www.google.com/schemas/sitemap-image/1.1').text.strip
    }
  }
end

call
