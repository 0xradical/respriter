# frozen_string_literal: true

call

payload = pipe_process.accumulator[:payload]
headers = pipe_process.accumulator[:response_headers]
json_ld = pipe_process.accumulator[:json_ld]
url     = pipe_process.initial_accumulator[:url]

document = Nokogiri::HTML(payload)
last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

course_name = document.css('h1.title').text
description = document.css('.LessonInfo .description p').first.text
instructors = [{name: document.css('.Instructor .name').text}]
languages   = ['en', 'en-US'] 
prices      = pipeline.data[:prices]

time        = json_ld[0][:timeRequired].split('H') #"5H44M"
effort      = time[0].to_f + (time[1].delete('M').concat(".0").to_f/60).round
lessons     = document.css('.LessonListItem').count 
duration    = {value: lessons, unit: 'lessons' }
workload    = {value: (effort*60.0/lessons).round, unit: 'minutes' }

image_url = json_ld[0][:image_url] 

syllabus = document.css('.LessonListItem').map do |lesson|
  title       = lesson.css('h3').text.strip
  detail = lesson.css('.description').text.strip
  "# #{title}\n\n#{detail}"
end.join "\n"

content = {
  id:                Digest::SHA1.hexdigest(url),
  image_url:         image_url,

  provider_id:       28856,
  provider_name:     'Frontend Masters',
  course_name:       course_name,
  description:       description,
  version:           '1.1.0',
  status:            'available',
  url:               url,
  instructors:       instructors,
  syllabus:          syllabus,

  prices:            prices,
  paid_content:      true,
  free_content:      false,
  
  pace:              'self_paced',
  duration:          duration,
  workload:          workload, 
  effort:            effort,

  language:          languages,
  audio:             languages,
  subtitles:         languages,
  published:         true,
  
  stale:             false,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld,
  extra: {
    sitemap:         pipe_process.data,
  }
}

content[:slug] = [
  I18n.transliterate(content[:course_name]).downcase,
  Resource.digest(Zlib.crc32(content[:url]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')


pipe_process.accumulator = {
  kind: :course,
  schema_version: '1.0.0',
  unique_id: Digest::SHA1.hexdigest(url),
  content: content,
  relations: Hash.new
}
