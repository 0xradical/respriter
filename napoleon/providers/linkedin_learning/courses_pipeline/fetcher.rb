search_course = pipe_process.accumulator
url           = search_course[:url]
pipe_process.accumulator = { url: url }

call

status_code = pipe_process.accumulator[:status_code]
raise "Something went wrong, got HTTP status #{status_code}" unless status_code == 200

json_ld  = pipe_process.accumulator[:json_ld]
payload  = pipe_process.accumulator[:payload]
headers  = pipe_process.accumulator[:response_headers]
document = Nokogiri::HTML(payload)

course_json_ld = json_ld.find{ |data| data[:@type] == 'Course' }

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

languages = [ search_course[:locale][:language] ]
if search_course[:locale][:country].present?
  languages << "#{search_course[:locale][:language]}-#{search_course[:locale][:country]}"
end

provided_tags = search_course[:associatedSkills].map{ |x| x[:name] }

course_info = document.css('.content__info__item__value').map do |info|
  key = (info.classes - ['content__info__item__value']).last
  [key, info.text]
end.to_h

canonical_url = document.css('link[rel="canonical"]').attribute('href').text.strip
raise "URL mismatch #{url} != #{canonical_url}" if url != canonical_url

video = nil
if search_course[:welcomeVideo].present?
  video = {
    url:           search_course[:welcomeVideo],
    thumbnail_url: search_course[:webThumbnail],
    type:          'raw',
    embed:         true
  }
end

level = case search_course[:difficultyLevel]
when 'BEGINNER'
  'beginner'
when 'BEGINNER_INTERMEDIATE'
  'beginner'
when 'INTERMEDIATE'
  'intermediate'
when 'INTERMEDIATE_ADVANCED'
  'intermediate'
when 'ADVANCED'
  'advanced'
when nil
  nil
else
  raise "Unmapped level #{search_course[:difficultyLevel]}"
end

free = true
price = nil
price_button = document.css('button.buy-course-upsell__button')
if price_button.present?
  free  = false
  price = document.css('button.buy-course-upsell__button').text.strip.match(/\d+\.\d+/)[0]
end

instructors = document.css('li.instructors__list-item').map do |node|
  {
    name:          node.css('h3.base-main-card__title').text.strip,
    distinguished: false,
    main:          true
  }
end

syllabus = course_json_ld[:hasPart].flatten.map do |part|
  "- #{part[:name]}"
end.join "\n"

duration_size = course_json_ld[:hasPart].size
effort        = course_json_ld[:hasPart].flatten.map{ |part| part[:duration] }.compact.map{ |d| Duration.new(d).total }.sum

prices = pipeline.data[:prices].dup
if price
  prices += [
    {
      type:         'single_course',
      price:        price,
      currency:     'USD',
      plan_type:    'regular',
      trial_period: { unit: 'months', value: 1 }
    }
  ]
end

content = {
  version:           '1.0.0',
  url:               url,
  course_name:       search_course[:title],
  paid_content:      !free,
  free_content:      free,
  provider_name:     'Linkedin Learning',
  prices:            pipeline.data[:prices],
  level:             level,
  language:          languages,
  audio:             languages,
  subtitles:         languages,
  status:            'available',
  tags:              provided_tags,
  provided_tags:     provided_tags,
  video:             video,
  description:       course_json_ld[:description],
  syllabus:          syllabus,
  pace:              'self_paced',
  instructors:       instructors,
  offered_by:        [],
  certificate:       { type: 'included' },
  extra_content:     nil,
  published:         true,
  stale:             false,
  # rating:            nil,
  aggregator_url:    nil,
  start_date:        nil,
  end_date:          nil,
  enrollment_urls:   nil,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld,
  extra: {
    json_ld:       json_ld,
    course_info:   course_info,
    search_course: search_course
  }
}
if duration_size > 0 && effort > 0
  content[:duration] = { value: duration_size,            unit: 'lessons' }
  content[:workload] = { value: (effort / duration_size), unit: 'seconds' }
  content[:effort]   = (effort/3600.0).round
end

content[:slug] = [
  I18n.transliterate(content[:course_name]).downcase,
  Resource.digest(Zlib.crc32(content[:url]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.accumulator = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(search_course[:$id]),
  content:   content,
  relations: Hash.new
}
