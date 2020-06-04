# frozen_string_literal: true

call

payload  = pipe_process.accumulator[:payload]
headers  = pipe_process.accumulator[:response_headers]
json_ld  = pipe_process.accumulator[:json_ld]

puts pipe_process.initial_accumulator[:url]

document = Nokogiri::HTML(payload)

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

course_name = document.css('h1.title').text
 
description = document.css('.LessonInfo .description p').text

instructor = document.css('.Instructor .name').text
instructors = [instructor]

course_brief = nil

rating = nil

languages = ['en']
 
alternate_course_url = nil
course_banner_info = nil

content = {
  provider_name:     'Frontend Masters',
  course_name:       course_name,
  version:           '1.1.0',
  status:            'available',
  url:               pipe_process.initial_accumulator[:url],
  # level:             nil,
  instructors:       instructors,
  start_date:        nil,
  end_date:          nil,
  enrollment_urls:   nil,
  prices:            [],
  certificate:       nil
  extra_content:     nil,
  paid_content:      true,
  free_content:      false,
  # # category:          nil,
  # # tags:              nil,
  provided_tags:     nil,
  provided_category: nil,
  description:       description,
  # syllabus:          syllabus,
  pace:              'self_paced',
  # duration:          duration,
  # workload:          workload,
  # effort:            effort,
  aggregator_url:    nil,
  rating:            nil,
  language:          languages,
  audio:             languages,
  subtitles:         languages,
  published:         true,
  # # reviewed:          false,
  stale:             alternate_course_url.present?,
  # alternate_course:  nil,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld,
  extra: {
    breadcrumb:           nil,
    sitemap:              pipe_process.data,
    course_brief:         course_brief,
    course_banner_info:   course_banner_info,
    alternate_course_url: alternate_course_url
  }
}

pipe_process.data[:course_payload] = payload

pipe_process.data = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}

