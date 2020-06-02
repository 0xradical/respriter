# frozen_string_literal: true

document = Nokogiri::XML(pipe_process.accumulator[:payload])
pipe_process.accumulator = document.css('url loc')
                                   .map(&:text)
                                   .map(&:strip)
                                   .find_all { |url| url.match(%r{frontendmasters.com/courses/[-\w]+/\z}) }
                                   .map { |url| { initial_accumulator: { url: url } } }

# /couser/smth/introduction perhaps
puts 'DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE'
puts 'DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE'
puts 'DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE'
puts 'DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE'
puts pipe_process.accumulator

call
