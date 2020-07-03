# frozen_string_literal: true

document = Nokogiri::XML(pipe_process.accumulator[:payload])
pipe_process.accumulator = document.css('url loc')
                                   .map(&:text)
                                   .map(&:strip)
                                   .find_all { |url| url.match(%r{domestika.org/[\w]+/courses/}) }
                                   .map { |url| { initial_accumulator: { url: url } } }

call
