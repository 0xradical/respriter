headers          = pipe_process.accumulator[:response_headers]
syllabus_payload = pipe_process.accumulator[:payload][:results]
payload          = pipe_process.data[:payload]

level = case payload[:instructional_level]
when nil
  nil
when ''
  nil
when 'All Levels'
  'beginner'
when 'Beginner Level'
  'beginner'
when 'Intermediate Level'
  'intermediate'
when 'Expert Level'
  'advanced'
else
  raise "New level: #{payload[:instructional_level].inspect}"
end

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

free = !payload[:is_paid]

published = !payload[:is_draft] && !payload[:is_banned] && !payload[:is_private] && payload[:is_published]

instructors = payload[:visible_instructors].map do |instructor|
  { name: instructor[:display_name], distinguished: false }
end

video_in_mintes = payload[:content_length_video]
duration = workload = effort = nil

chapter_size = syllabus_payload.count{ |item| item[:_class] == 'chapter' }
if chapter_size > 0
  duration = { value: chapter_size, unit: 'lessons' }
  workload = { value: (video_in_mintes.to_f / chapter_size).round, unit: 'minutes' }
  effort   = (video_in_mintes/3600.0).ceil
end

prices = []
unless free
  if payload[:discount_price].present?
    prices.push(
      type:           'single_course',
      plan_type:      'regular',
      price:          format('%.2f', payload[:discount_price][:amount]),
      original_price: format('%.2f', payload[:price_detail][:amount]),
      discount:       format('%.2f', (payload[:price_detail][:amount] - payload[:discount_price][:amount])),
      currency:       payload[:price_detail][:currency],
    )
  else
    prices.push(
      type:      'single_course',
      plan_type: 'regular',
      price:     format('%.2f', payload[:price_detail][:amount]),
      currency:  payload[:price_detail][:currency],
    )
  end
end

parse_string = lambda do |locale_string|
  language, region = locale_string.split '_'
  region.nil? ? language.downcase : "#{language.downcase}-#{region.upcase}"
end

main_language = parse_string.call payload[:locale][:locale]

subtitles = payload[:caption_locales].map do |caption|
  parse_string.call caption[:locale]
end

category    = payload[:primary_category]&.[](:title)
subcategory = payload[:primary_subcategory]&.[](:title)

image_url = payload[:image_750x422]

syllabus = syllabus_payload.map do |item|
  if item[:_class] == 'chapter'
    "# #{item[:title]}\n"
  else
    "* #{item[:title]}"
  end
end.join "\n"

content = {
  provider_name:     'Udemy',
  course_name:       payload[:title],
  image_url:         image_url,
  version:           '1.1.0',
  status:            'available',
  url:               "https://www.udemy.com#{payload[:url]}",
  level:             level,
  instructors:       instructors,
  start_date:        nil,
  end_date:          nil,
  enrollment_urls:   nil,
  prices:            prices,
  certificate:       { type: 'free' },
  extra_content:     nil,
  paid_content:      !free,
  free_content:      free,
  # category:          nil,
  # tags:              nil,
  provided_tags:     [category, subcategory].compact,
  provided_category: category,
  description:       ReverseMarkdown.convert(payload[:description]),
  syllabus:          syllabus,
  pace:              'self_paced',
  duration:          duration,
  workload:          workload,
  effort:            effort,
  aggregator_url:    nil,
  rating:            { type: 'stars', value: payload[:rating], range: 5 },
  language:          [ main_language ],
  audio:             [ main_language ],
  subtitles:         subtitles,
  published:         published,
  # reviewed:          false,
  stale:             false,
  alternate_course:  nil,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           nil,
  extra: {
    pipeline_execution: pipe_process.pipeline.pipeline_execution_id,
    course:             payload,
    syllabus_payload:   syllabus_payload
  }
}

if payload[:promo_asset].present?
  content[:video] = {
    type:          'video_service',
    path:          "udemy/#{payload[:id]}",
    thumbnail_url: image_url
  }
else
  if syllabus_payload.find{ |l| l[:_class] == 'lecture' && l[:is_free] && l[:asset]&.[](:download_urls)&.[](:Video).present? }
    content[:video] = {
      type:          'video_service',
      path:          "udemy/#{payload[:id]}/first_lecture",
      thumbnail_url: image_url
    }
  end
end

content[:slug] = [
  I18n.transliterate(content[:course_name].to_s).downcase,
  Resource.digest(Zlib.crc32(content[:extra][:course][:id].to_s))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')
  .gsub(/[\s\_\-]+/, '-')

pipe_process.accumulator = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest("udemy-#{content[:extra][:course][:id]}"),
  content:   content,
  relations: Hash.new
}

call

pipe_process.data = nil
