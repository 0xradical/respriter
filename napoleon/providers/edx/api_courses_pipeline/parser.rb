call
provider_types = {  "CollegeOrUniversity" => 'university' }.tap{|h| h.default = 'other'}
levels         = { "Introductory" => "beginner", "Intermediate" => "intermediate", "Advanced" => "advanced" }
statuses       = { "Archived" => "finished", "Current" => "available", "Starting Soon" => "coming_soon", "Upcoming" => "upcoming" }
url            = pipe_process.data[:course_url]
json_ld        = pipe_process.data[:json_ld]
graph          = json_ld&.[](:@graph)
course         = graph&.select{|node| node[:@type] == 'Course' }&.first
provider       = course&.[](:provider)
offered_by     = Array.wrap(provider && provider[:name] && [{ type: provider_types[provider[:@type]], name:  provider[:name], main: true }])
course_run     = pipe_process.accumulator[:payload]
course_id      = course_run[:course]
course_num     = course_run[:number]
course_org     = course_run[:org]
course_name    = course_run[:title]
syllabus       = course_run[:syllabus_raw]
start_date     = (Time.parse(course_run[:start]).strftime('%Y/%m/%d') rescue nil)
end_date       = (Time.parse(course_run[:end]).strftime('%Y/%m/%d') rescue nil)
enroll_start   = (Time.parse(course_run[:enrollment_start]).strftime('%Y/%m/%d') rescue nil)
enroll_end     = (Time.parse(course_run[:enrollment_end]).strftime('%Y/%m/%d') rescue nil)
pace           = course_run[:pacing_type] || 'self_paced'
course_type    = course_run[:type]
course_status  = course_run[:status]
description    = course_run[:full_description]
video_url      = course_run.dig(:video, :src)
video          = (video_url and { type: 'youtube', id: URI.parse(video_url).query.split('&').map{|s| s.split('=') }.to_h['v'], embed: true })
subtitles      = course_run.dig(:transcript_languages)
instructors    = course_run[:staff].each_with_index.map{|person, index| { name: person[:given_name] + " " + person[:family_name], distinguished: false, main: (index == 0) }  }
duration       = (course_run[:max_effort] && { value: course_run[:max_effort], unit: 'hours' })
workload       = (course_run[:weeks_to_complete] && { value: course_run[:weeks_to_complete], unit: 'weeks' })
effort         = (course_run[:weeks_to_complete] and course_run[:max_effort] and course_run[:weeks_to_complete]*course_run[:max_effort])
course_level   = levels[course_run[:level_type]] || []
language       = Array.wrap(course_run[:language])
availability   = course_run[:availability]
status         = statuses[availability]
hidden         = course_run[:hidden]
seats          = course_run[:seats].map{|seat| {type: seat[:type], price: seat[:price], currency: seat[:currency] }}
unpublished    = (course_status == 'unpublished') || (course_status == 'published' && !!hidden)
version        = '1.0.1'
slug           = [url.gsub('https://www.edx.org/course/','').gsub('/','').gsub('+','-').downcase,Resource.digest(Zlib.crc32(url))].join('-').gsub(/[[:blank:]_-]+/, '-').gsub(/[^0-9a-z-]/i, '').gsub(/(^-)|(-$)/, '')
extras         = {
  seats: seats,
  syllabus: syllabus,
  course_id: course_id,
  course_num: course_num,
  course_org: course_org,
  course_type: course_type,
  course_status: course_status,
  video_url: video_url,
  availability: availability,
  hidden: hidden,
}

prices      = []
certificate = nil

if course_type == "professional" || course_type == "no-id-professional"
  prices = seats.select{|seat| seat[:type] == course_type}.map do |seat|
    {
      type: 'single_course',
      customer_type: 'individual',
      plan_type: 'regular',
      price: seat[:price],
      currency: seat[:currency]
    }
  end
else
  prices = [
    {
      type: 'single_course',
      customer_type: 'individual',
      plan_type: 'regular',
      price: '0.00',
      currency: 'USD'
    }
  ]
  if course_type == "credit" || course_type == "verified"
    certificate_seat = seats.select{|seat| seat[:type] == course_type}.first
    certificate      = certificate_seat ? { type: 'paid', price: certificate_seat[:price], currency: certificate_seat[:currency] } : nil
  else # honor / audit
    certificate      = nil
  end
end

content = {
  slug: slug,
  course_name: course_name,
  level: course_level,
  provider_name: 'edX',
  instructors: instructors,
  certificate: certificate,
  url: url,
  offered_by: offered_by,
  description: description,
  pace: pace,
  effort: effort,
  workload: workload,
  duration: duration,
  rating: nil,
  language: language,
  audio: language,
  subtitles: subtitles,
  prices: prices,
  published: !unpublished,
  json_ld: json_ld,
  extras: extras,
  version: version
}

if enroll_start && (enroll_start > Time.now)
  content[:status]    = "coming_soon"
  content[:published] = true
end

if enroll_end && (enroll_end < Time.now)
  content[:status]    = "unavailable"
  content[:published] = false
end

validator_opts = {}

if video
  content[:video] = video
  validator_opts = {
    fields: [
      [:video, format: true, presence: true],
      [:subtitles, format: true, presence: true]
    ]
  }
end

pipe_process.accumulator = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new,
  validator: validator_opts
}
