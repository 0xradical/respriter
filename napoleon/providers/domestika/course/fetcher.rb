# frozen_string_literal: true

call

payload  = pipe_process.accumulator[:payload]
headers  = pipe_process.accumulator[:response_headers]
json_ld  = pipe_process.accumulator[:json_ld]
url      = pipe_process.initial_accumulator[:url]

document = Nokogiri::HTML(payload)

audio_language = document.css('.course-details-list .fi-dmstk-volume').last.parent.text.delete("\n").split(' ').last
page_language = document.css('.btn-group .language .active').text.delete("\n")

if audio_language != page_language
  raise Pipe::Error.new(:skipped, 'Ignore this language version')
end

language_codes = {
  'aleman'         => 'de',
  'alemao'         => 'de',
  'deutsch'        => 'de',
  'englisch'       => 'en',
  'english'        => 'en',
  'espanhol'       => 'es',
  'espanol'        => 'es',
  'german'         => 'de',
  'ingles'         => 'en',
  'portugiesisch'  => 'pt-BR',
  'portugues'      => 'pt-BR',
  'portuguese'     => 'pt-BR',
  'spanisch'       => 'es',
  'spanish'        => 'es',
}

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

course_name = course_name = document.css('.course-header-new__title').text.delete("\n")
instructors = [{name: document.css(".js-teacher-popover-link").first.text}]
description = (document.css(".course-header-new__short-description").first.text + ". " + document.css(".course-landing__description .text-body-bigger-new").first.text).delete("\n")

audio = [language_codes[audio_language.parameterize]]

cc_element = document.css('.course-details-list .fi-dmstk-cc').last
subtitles = cc_element ? cc_element.parent.text.delete("\n ").split(',').map{ |k| language_codes[k.parameterize] } : []
languages   = audio

prices      = [{
  type:      'single_course',
  plan_type: 'regular',
  price:     json_ld[0][:price],
  currency:  json_ld[0][:priceCurrency]
}]

thumbnail_url = json_ld[1][1][:thumbnailUrl]

magic_number = document.css('.video-container--with-shadow').first.attributes['class'].value[/(?<=js_vimeo_video_item_)(\d+)/]
uri = URI("https://www.domestika.org/api/video_items/#{magic_number}")
video_id = Net::HTTP.get(uri)[/(?<=player.vimeo.com\/video\/)(\d+)/]

video = {
  type:          'vimeo',
  id:            video_id,
  thumbnail_url: thumbnail_url
} 

syllabus = []
document.css('.toc-new .toc-new__item').each do |k|
  syllabus << "# #{k.css(".toc-new__unit-title").text.delete("\n")}\n"
  k.css(".toc-new__lesson-item").each do |j|
    syllabus << j.text.delete("\n") 
  end
  syllabus << "\n"
end

course_id = url[/(?<=courses\/)(\d+)/]

content = {
  id:                Digest::SHA1.hexdigest(course_id),
  video:             video,

  provider_id:       28857,
  provider_name:     'Domestika',
  course_name:       course_name,
  description:       description,
  version:           '1.1.0',
  status:            'available',
  url:               url,
  instructors:       instructors,
  syllabus:          syllabus.join("\n"),

  prices:            prices,
  paid_content:      true,
  free_content:      false,
  
  pace:              'self_paced',
  language:          languages,
  audio:             audio,
  subtitles:         subtitles,
  published:         true,
  
  stale:             false,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld,
  extra: {
    sitemap:         pipe_process.data,
  }
}

time_details = document.css('.course-details-list .fi-dmstk-film') 

if time_details.present?
  lessons_time = time_details.last.parent.text.delete("\n)").split('(') #["13 Lecciones ", "1h 39m"]
  lessons     = lessons_time[0][/\d+/] #13
  duration    = {value: lessons.to_i, unit: 'lessons' } 
  if lessons_time[1]  
    hours       = lessons_time[1][/(\d+\s*)(?=h)/].to_f || 0.0
    minutes     = lessons_time[1][/(\d+\s*)(?=m)/]&.concat(".0")&.to_f || 0.0
    effort      = hours + (minutes/60.0)
    workload    = {value: (effort*60.0/lessons.to_f).round, unit: 'minutes' }
    effort      = effort.round

    content[:duration] = duration
    content[:workload] = workload
    content[:effort]   = effort
  end
end

content[:slug] = [
  I18n.transliterate(content[:id]).downcase,
  Resource.digest(Zlib.crc32(content[:id]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')


pipe_process.accumulator = {
  kind: :course,
  schema_version: '1.0.0',
  unique_id: Digest::SHA1.hexdigest(course_id),
  content: content,
  relations: Hash.new
}

puts pipe_process.accumulator
