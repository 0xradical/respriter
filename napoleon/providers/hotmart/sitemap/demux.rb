# frozen_string_literal: true

document = Nokogiri::XML(pipe_process.accumulator[:payload])

sitemaps = document.css('sitemap loc').map(&:text).map(&:strip).find_all { |url| url.match(%r{https://www.hotmart.com/product/}) }

accumulator = []
sitemaps.each do |sitemap| 
  doc = Nokogiri::XML(open(sitemap))
  accumulator += doc.css('url loc').map(&:text).map(&:strip).find_all { |url| url.match(%r{https://www.hotmart.com/product/}) }.map { |url| { initial_accumulator: { url: url } } }
end

pipe_process.accumulator = accumulator

call
