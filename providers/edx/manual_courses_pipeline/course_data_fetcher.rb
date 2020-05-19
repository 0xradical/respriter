call
provider_types = {  "CollegeOrUniversity" => 'university' }.tap{|h| h.default = 'other'}
levels         = { "Introductory" => "beginner", "Intermediate" => "intermediate", "Advanced" => "advanced" }
statuses       = { "Archived" => "finished", "Current" => "available", "Starting Soon" => "coming_soon", "Upcoming" => "upcoming" }
payload        = pipe_process.accumulator[:payload]
course         = payload[:result][:pageContext][:course]
url            = pipe_process.initial_accumulator[:url]
course_run     = course[:activeCourseRun]
course_run_id  = course_run[:uuid]
course_id      = course[:uuid]
course_name    = course[:title]
offered_by     = Array.wrap(course[:owners]&.each_with_index&.map{ |owner, index| { type: provider_types[owner[:type]], name: owner[:name], main: (index == 0) } })
syllabus       = course[:syllabusRaw]
start_date     = (Time.parse(course_run[:start]).strftime('%Y/%m/%d') rescue nil)
end_date       = (Time.parse(course_run[:end]).strftime('%Y/%m/%d') rescue nil)
pace           = course_run[:pacingType] || 'self_paced'
course_type    = course_run[:type]
course_status  = course_run[:status]
description    = course[:fullDescription]
video_url      = course.dig(:video, :src)
video_img      = course.dig(:video, :image, :src)
video          = (video_url and { type: 'youtube', id: CGI.parse(URI.parse(video_url).query).map{|k,v| [k,v.first] }.to_h['v'], embed: true })
subtitles      = Array.wrap(course_run[:contentLanguage])
instructors    = course_run[:staff].each_with_index.map{|person, index| { name: person[:givenName] + " " + person[:familyName], distinguished: false, main: (index == 0) }  }
duration       = (course_run[:maxEffort] && { value: course_run[:maxEffort], unit: 'hours' })
workload       = (course_run[:weeksToComplete] && { value: course_run[:weeksToComplete], unit: 'weeks' })
effort         = (course_run[:weeksToComplete] and course_run[:maxEffort] and course_run[:weeksToComplete]*course_run[:maxEffort])
course_level   = levels[course[:levelType]] || []
language       = Array.wrap(course_run[:contentLanguage])
availability   = course_run[:availability]
status         = statuses[availability]
hidden         = course_run[:hidden]
unpublished    = (course_status == 'unpublished') || (course_status == 'published' && !!hidden)
seats          = course_run[:seats].map{|seat| {type: seat[:type], price: seat[:price], currency: seat[:currency] }}
version        = '1.0.1'

slug = [
  'edx',
  url.gsub('https://www.edx.org/course/','')
    .gsub('/','')
    .gsub('+','-')
    .downcase,
  Resource.digest(Zlib.crc32(url))
].join('-')
  .gsub(/[[:blank:]_-]+/, '-')
  .gsub(/[^0-9a-z-]/i, '')
  .gsub(/(^-)|(-$)/, '')

extras = {
  seats:         seats,
  syllabus:      syllabus,
  course_id:     course_id,
  course_run_id: course_run_id,
  course_type:   course_type,
  course_status: course_status,
  video_url:     video_url,
  availability:  availability
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
  extras: extras,
  version: version
}

if start_date && (start_date > Time.now)
  content[:status]    = "coming_soon"
  content[:published] = true
end

if end_date && (end_date < Time.now)
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
