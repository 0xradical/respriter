call

payload      = pipe_process.accumulator[:payload]
document     = Nokogiri::HTML(payload)
level_map    = { "novice" => "beginner", "beginner" => "beginner", "intermediate" => "intermediate", "advanced" => "advanced" }
minutes_rgx  = Regexp.new(["5e283f3c6d696e757465733e5c642b292d6d696e75746520283f3c63617465676f72793e2e2a2920436f7572736524"].pack('H*'))
url          = pipe_process.initial_accumulator[:url]
course_name  = document.css('#syllabus-title h1').text.strip
free_content = true # only the first stage of the course
paid_content = true # the rest of the course
language     = ['en', 'en-US']
effort       = document.css('#syllabus-title h2.markdown-zone').text.strip.match(minutes_rgx)&.[](:minutes)&.to_f&./(60.0)
status       = effort.nil? ? 'upcoming' : 'available'
prices       = pipeline.data[:prices]
description  = ReverseMarkdown.convert(document.css('#syllabus-description').to_s)
slug         = [I18n.transliterate(course_name).downcase,Resource.digest(Zlib.crc32(url))].join('-').gsub(/[[:blank:]_-]+/, '-').gsub(/[^0-9a-z-]/i, '').gsub(/(^-)|(-$)/, '')
level        = level_map[document.css('#syllabus-skill-level').text().strip().downcase]
instructors  = document.css('#syllabus-authors li a h4').each_with_index.map{ |author_name, index| { name: author_name.text(), distinguished: false, main: (index == 0) } }

content = {
  url:             url,
  language:        language,
  instructors:     instructors,
  offered_by:      [],
  pace:            'self_paced',
  level:           level,
  audio:           language,
  subtitles:       language,
  prices:          prices,
  status:          status,
  description:     description,
  course_name:     course_name,
  paid_content:    paid_content,
  free_content:    free_content,
  provider_name:   'Treehouse',
  reviewed:        false,
  published:       true,
  effort:          effort,
  slug:            slug,
  version:         '1.0.0'
}

pipe_process.data = { content: content }

video_page_url = nil
is_trailer     = false
http_headers   = {}
trailer_url    = URI.parse(url).tap{|uri| uri.path += '/trailer' }
cookies        = pipe_process.accumulator[:cookie_jar]

if document.css("[data-src='" + trailer_url.path + "']").present?
  video_page_url = trailer_url.to_s
  is_trailer     = true
  http_headers   = { :'X-CSRF-Token' => document.css("meta[name='csrf-token']").attribute('content').text, :'X-Requested-With' => 'XMLHttpRequest' }
else
  # algumas páginas não tem trailer mas tem primeiro video em /stages
  # ex.: https://teamtreehouse.com/library/rest-apis-with-express
  pipe_process.accumulator[:url] = url + '/stages'

  # TODO: Dont invoke call twice in a pipe... this breaks atomicity and may cause hard to debug errors
  call
  if pipe_process.accumulator[:status_code] == 404
    pipe_process.status = :pending
  else
    payload      = pipe_process.accumulator[:payload]
    document     = Nokogiri::HTML(payload)
    first_lesson = document.css('.steps-list li a')&.first&.attribute('href')&.text()

    if first_lesson
      video_page_url = URI.parse(url).tap{ |uri| uri.path = first_lesson }.to_s
      is_trailer     = false
    end
  end
end

if video_page_url
  pipe_process.accumulator = { url: video_page_url, trailer: is_trailer, http: { headers:  http_headers, cookies: cookies } }
else
  pipe_process.data[:skip_video] = true
end
