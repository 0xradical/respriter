call

payload  = pipe_process.accumulator[:payload]
document = Nokogiri::HTML(payload)

free = false
language = [ 'en', 'en-US', 'en-GB', 'es', 'es-ES', 'fr', 'fr-FR', 'it', 'it-IT', 'pt', 'pt-BR', 'sv', 'sv-SV', 'pl', 'pl-PL' ]
category = 'computer_science'

tags = document.css('.breadcrumbs a').map &:text
course_name = document.css('h1').first.text

unless course_name.match(Regexp.new tags.first, Regexp::IGNORECASE)
  course_name = "#{tags.first} Language - #{course_name}"
end

case tags.first
when 'Danish'
  language = language.find_all{ |x| !x.match /da/ }
when 'Dutch'
  language = language.find_all{ |x| !x.match /nl/ }
when 'English'
  language = language.find_all{ |x| !x.match /en/ }
when 'French'
  language = language.find_all{ |x| !x.match /fr/ }
when 'German'
  language = language.find_all{ |x| !x.match /pt/ }
when 'Indonesian'
  language = language.find_all{ |x| !x.match /i[dn]/ }
when 'Italian'
  language = language.find_all{ |x| !x.match /it/ }
when 'Norwegian'
  language = language.find_all{ |x| !x.match /no/ }
when 'Portuguese'
  language = language.find_all{ |x| !x.match /pt/ }
when 'Russian'
  language = language.find_all{ |x| !x.match /ru/ }
when 'Spanish'
  language = language.find_all{ |x| !x.match /es/ }
when 'Swedish'
  language = language.find_all{ |x| !x.match /sv/ }
when 'Turkish'
  language = language.find_all{ |x| !x.match /tr/ }
when 'Polish'
  language = language.find_all{ |x| !x.match /pl/ }
end

raise "TODO: Invalid Format! Update it!"

content = {
  url:             pipe_process.initial_accumulator[:url],
  tags:            tags,
  language:        language,
  audio:           language,
  subtitles:       language,
  stale:           false,
  price:           pipeline.data[:prices].min_by{ |x| x[:price] }[:price],
  currency:        'USD',
  price_details:   'monthly subscription',
  status:          nil,
  category:        'language_and_communication',
  duration:        nil,
  workload:        nil,
  syllabus:        nil,
  description:     ReverseMarkdown.convert(document.css('.description').to_s),
  course_name:     course_name,
  paid_content:    !free,
  free_content:    free,
  provider_name:   'Babbel',
  reviewed:        false,
  published:       true,
  effort:          nil,
  rating:          nil
}

content[:slug] = [
  I18n.transliterate(content[:course_name]).downcase,
  Resource.digest(Zlib.crc32(content[:url]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.accumulator = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}
