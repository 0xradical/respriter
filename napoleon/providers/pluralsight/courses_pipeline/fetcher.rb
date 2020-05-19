call

payload  = pipe_process.accumulator[:payload]
document = Nokogiri::HTML(payload)

selectors = {
  name: ".title h1",
  description: "#course-page-description .text-component, .course-description-tile .course-info-tile-right > p",
  creator: ".title--alternate a",
  review_count: "meta[name='rating-count']",
  rating_value: "meta[name='rating']"
}

url               = pipe_process.accumulator[:current_url]
language          = 'en'
free              = false
course_name       = ( document.css(selectors[:name]).text.presence.strip rescue raise Pipe::Error.new(:skipped, 'Course has no name') )
instructors       = document.css(selectors[:creator])&.each_with_index&.map{|creator, index| { name: creator.text.strip, distinguished: false, main: (index == 0) } }
free_content      = false
paid_content      = true
description       = (document.css(selectors[:description]).text.presence.strip rescue raise Pipe::Error.new(:skipped, 'Course has no description'))
pace              = 'self_paced'
version           = '1.0.0'
status            = 'available'
rating_node       = document.css(selectors[:rating_value]).first
rating            = rating_node && { type: 'stars', value: rating_node.text.strip.to_f, range: [0, 5] }
extras            = document.css('meta[name]').map do |meta|
                      meta.attributes.inject({}) do |h, (k, v)|
                        h.merge({k => v.value})
                      end
                    end.inject({}) do |all, h|
                      all.merge({h['name'] => h['content']})
                    end
level             = extras['skill-levels']&.downcase
slug              = [I18n.transliterate(course_name).downcase,Resource.digest(Zlib.crc32(url))].join('-').gsub(/[[:blank:]_-]+/, '-').gsub(/[^0-9a-z-]/i, '').gsub(/(^-)|(-$)/, '')

effort_node = document.css('#course-description-tile-info > div.course-info__row.clearfix').find do |node|
  node.css('.course-info__row--left').text == 'Duration'
end

effort = nil
if effort_node.present?
  effort_text = effort_node.css('.course-info__row--right').text.strip
  match = effort_text.match(/[[:blank:]]*((?<hours>[[:digit:]]+)h)?[[:blank:]]*((?<minutes>[[:digit:]]+)m)?[[:blank:]]*/)
  if match
    effort = match[:hours].to_i + match[:minutes].to_i/60.0
  end
end

content = {
  status: status,
  slug: slug,
  course_name: course_name,
  level: level,
  provider_name: 'Pluralsight',
  instructors: instructors,
  url: url,
  offered_by: [],
  prices: pipeline.data[:prices],
  certificate: { type: 'included' },
  free_content: free_content,
  paid_content: paid_content,
  description: description,
  pace: pace,
  effort: effort,
  rating: rating,
  language: [ language ],
  audio: [ language ],
  published: true,
  stale: false,
  json_ld: {},
  extra: extras.slice(*%w(description subjects skill-levels roles tools certifications publish-date categories)).reject{|k,v| v.nil?},
  version: version
}

video_uri = document.css('a.button-overview_vid').attribute('href').value rescue nil

if video_uri.present? && video_uri != '#'
  thumbnail_url = document.css('meta[property="og:image"]').attribute('content').text.strip
  pipe_process.accumulator = {
    url:           video_uri.to_s,
    content:       content,
    skip_video:    false,
    thumbnail_url: thumbnail_url
  }
else
  pipe_process.accumulator = {
    content:    content,
    skip_video: true
  }
end
