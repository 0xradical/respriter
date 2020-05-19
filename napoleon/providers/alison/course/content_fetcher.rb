payload = pipe_process.accumulator[:payload]
json_ld = pipe_process.accumulator[:json_ld]
headers = pipe_process.accumulator[:response_headers]

document = Nokogiri::HTML(payload)

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

raise Pipe::Error.new(:skipped, 'Not a course page') if document.css('.new-course-layout').blank?

course_name = document.css('.course-brief h1').text
description = ReverseMarkdown.convert document.css('.course-brief--description').text

breadcrumb = document.css('ol.breadcrumb li a').map(&:text)

tags = document.css('.course-tabs-tags li span.tag-name').map(&:text)

course_banner_info = document.css('.course-banner .course-icons h4').map(&:text).zip(
  document.css('.course-banner .course-icons span').map(&:text)
)

course_brief = document.css('.course-brief .course-icons h3').map(&:text).zip(
  document.css('.course-brief .course-icons span').map(&:text)
)

alternate_course_url = nil
if document.css('.new_course_notification').present?
  alternate_course_url = document.css('.new_course_notification a')[1].attribute('href').text
end

rating = course_banner_info[1][0].match(/\d(\.\d)?/)[0].to_f rescue "Fudeu #{ course_banner_info[1].inspect }"

languages     = document.css('link[rel="alternate"]').map{ |t| t.attribute('hreflang').text } - ['x-default']
main_language = pipe_process.data[:language]

content = {
  provider_name:     'Alison',
  course_name:       course_name,
  version:           '1.1.0',
  status:            'available',
  url:               pipe_process.initial_accumulator[:url],
  # level:             nil,
  instructors:       [],
  start_date:        nil,
  end_date:          nil,
  enrollment_urls:   nil,
  prices:            [],
  certificate:       { type: 'paid' },
  extra_content:     nil,
  paid_content:      true,
  free_content:      true,
  # # category:          nil,
  # # tags:              nil,
  provided_tags:     tags,
  provided_category: breadcrumb[1..-1],
  description:       description,
  # syllabus:          syllabus,
  pace:              'self_paced',
  # duration:          duration,
  # workload:          workload,
  # effort:            effort,
  aggregator_url:    nil,
  rating:            rating,
  language:          languages,
  audio:             languages,
  subtitles:         [ main_language ],
  published:         true,
  # # reviewed:          false,
  stale:             alternate_course_url.present?,
  # alternate_course:  nil,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld,
  extra: {
    breadcrumb:           breadcrumb,
    sitemap:              pipe_process.data,
    course_brief:         course_brief,
    course_banner_info:   course_banner_info,
    alternate_course_url: alternate_course_url
  }
}

content[:slug] = [
  I18n.transliterate(content[:course_name].to_s).downcase,
  Resource.digest(Zlib.crc32(content[:url].to_s))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.data[:course_payload] = payload

pipe_process.data = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}

translated_content = case main_language.to_sym
when :en
  'content'
when :es
  'contenido'
when :it
  'contenuto'
when :fr
  'contenu'
when :'pt-BR'
  'content'
else
  raise "Missing language #{ main_language }"
end

pipe_process.accumulator = {
  url: "#{pipe_process.initial_accumulator[:url]}/#{translated_content}"
}

call
