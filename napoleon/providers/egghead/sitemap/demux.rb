# frozen_string_literal: true

sitemap_url = 'https://egghead-sitemaps.s3.amazonaws.com/sitemaps/sitemap.xml.gz'

document = Nokogiri::XML(Zlib::GzipReader.new(open(sitemap_url)).read)

pipe_process.accumulator = document.css('url loc')
                                   .map(&:text)
                                   .map(&:strip)
                                   .find_all { |url| url.match(%r{egghead.io/courses/}) }
                                   .map { |url| { initial_accumulator: { url: url } } }

call
