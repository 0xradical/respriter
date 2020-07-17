# frozen_string_literal: true

document = Nokogiri::XML(pipe_process.accumulator[:payload])
pipe_process.accumulator = document.css('url loc')
                                   .map(&:text)
                                   .map(&:strip)
                                   .find_all { |url| url.match(%r{codecademy.com/learn/}) }
                                   .map { |url| { initial_accumulator: { url: url } } }
call
