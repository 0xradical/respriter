call

payload  = pipe_process.accumulator[:payload]
headers  = pipe_process.accumulator[:response_headers]
json_ld  = pipe_process.accumulator[:json_ld]
document = Nokogiri::HTML(payload)
free     = false
language = [ 'en', 'en-US' ]

canonical_url = document.css('meta[property="og:url"]').attribute('content').text.strip
course_info   = Oj.load(document.css('head').attribute('data-course').text).symbolize_keys

video_json_ld = json_ld.find{ |json| json[:@type] == 'VideoObject'}

# MasterClass don't gives its rating public, but says that in average they are 4.7
rating = 4.7

lessons = document.css('.cm-lesson').size
last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

instructor = document.css('h1.class-header span.instructor').text.strip

instructors = [
  { name: instructor, distinguished: true, main: true }
]

syllabus = document.css('.cm-lesson').map do |lesson|
  title       = lesson.css('h2.lesson-title').text.strip
  description = lesson.css('p').text.strip

  "# #{title}\n\n#{description}"
end.join "\n"

subscription_price = document.css('.cm-ctas-block__pricing-description').text.match(/\$([^\s]*)/)[1]

prices = [
  { type: 'single_course', price: course_info[:course_price], currency: course_info[:currency] },
  { type: 'subscription',  price: subscription_price,         currency: course_info[:currency], total_price: subscription_price, subscription_period: { value: 1, unit: 'years' }, payment_period: { value: 1, unit: 'years' } }
]

content = {
  provider_name:     'MasterClass',
  course_name:       json_ld[0][:name],
  version:           '1.0.0',
  status:            'available',
  level:             nil,
  url:               canonical_url,
  instructors:       instructors,
  offered_by:        [],
  start_date:        nil,
  end_date:          nil,
  enrollment_urls:   nil,
  prices:            prices,
  certificate:       nil,
  extra_content:     nil,
  free_content:      false,
  paid_content:      true,
  # category:          nil,
  # tags:              nil,
  provided_tags:     nil,
  provided_category: nil,
  description:       course_info[:overview],
  syllabus:          syllabus,
  pace:              'self_paced',
  duration:          { value: lessons, unit: 'lessons' },
  workload:          { value: 12, unit: 'minutes' },
  effort:            (lessons*12.0/60).round,
  aggregator_url:    nil,
  rating:            { type: 'stars', value: rating, range: 5 },
  language:          language,
  audio:             language,
  subtitles:         language,
  published:         true,
  # reviewed:          false,
  stale:             false,
  video:             { url: video_json_ld[:embedUrl], thumbnail_url: video_json_ld[:thumbnailUrl], type: 'brightcove' },
  alternate_course:  nil,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld,
  extra: {
    course_info:   course_info,
    canonical_url: canonical_url
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
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}
