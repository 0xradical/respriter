document = Nokogiri::XML(pipe_process.accumulator[:payload])
  pipe_process.accumulator = document.css('url loc')
    .map(&:text)
    .map(&:strip)
    .find_all{ |url| url.match /^https:\/\/www.babbel.com\/learn-[-\w]+-online\/\d+[-\w]+\/\d+[-\w]+$/ }
    .map{ |url| { initial_accumulator: { url: url } } }

call
