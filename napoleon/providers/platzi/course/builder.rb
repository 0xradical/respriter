payload        = pipe_process.accumulator[:payload]
headers        = pipe_process.accumulator[:response_headers]
json_ld        = pipe_process.accumulator[:json_ld]
course_json_ld = json_ld.group_by{ |value| value[:@type].downcase.to_sym }.map{ |type, jsons| [type, jsons.first] }.to_h[:course]
document       = Nokogiri::HTML.fragment payload
language       = [ 'es', 'es-ES' ]

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

free = course_json_ld&.[](:isAccessibleForFree) == 'true'

canonical_url = document.css('link[rel="canonical"]').attribute('href').text

raw_prices = document.css('.PlanColumn-details').map{ |doc| [ doc.css('.PlanColumn-subtitle').text, doc.css('.PlanColumn-cost').text.gsub('$','') ] }.to_h

prices = []

if price = raw_prices['1 solo curso, 1 solo pago']
  prices << { type: 'single_course', price: price, currency: 'USD' }
end

if price = raw_prices['Pagas mes a mes']
  prices << { type: 'subscription', price: price, currency: 'USD', total_price: price, subscription_period: { value: 1, unit: 'months' }, payment_period: { value: 1, unit: 'months' } }
end

if price = raw_prices.map{ |k,v| /En un solo pago de \$(\d+)/.match k }.compact.first&.[](1)
  prices << { type: 'subscription', price: price, currency: 'USD', total_price: price, subscription_period: { value: 1, unit: 'years' }, payment_period: { value: 1, unit: 'years' } }
end

instructors = document.css('.Teacher-name').map do |doc|
  { name: doc.text.strip, distinguished: false, main: true }
end

name = document.css('div.Hero-course-info h1').text

syllabus = document.css('.ConceptList-syllabus').map do |doc|
  doc.css('section.MaterialList').map do |doc|
    [
      "# #{doc.css('h3').text}",
      *doc.css('.Material-name').map(&:text).map(&:strip).map{ |x| "* #{x}" }.join("\n")
    ].join "\n\n"
  end.join "\n\n"
end.join "\n\n"

video = nil
video_iframe = document.css('.BannerTop-trailer iframe').first
if video_iframe.present?
  iframe_src = video_iframe.attribute('src').text
  video_id   = /youtube\.com\/embed\/(.*)\?/.match(iframe_src)[1]
  video = {
    type: 'youtube',
    id:   video_id
  }
end

rating = course_json_ld&.[](:aggregateRating)&.[](:aggregateValue).to_s

content = {
  provider_name:     'Platzi',
  provider_id:       28807,
  course_name:       name,
  version:           '1.1.0',
  status:            'available',
  id:                canonical_url,
  url:               canonical_url,
  instructors:       instructors,
  offered_by:        [],
  start_date:        nil,
  end_date:          nil,
  enrollment_urls:   nil,
  prices:            prices,
  certificate:       { type: 'free' },
  free_content:      free,
  paid_content:      !free,
  description:       course_json_ld&.[](:description),
  syllabus:          syllabus,
  pace:              'self_paced',
  # duration:          nil,
  # workload:          nil,
  # effort:            nil,
  aggregator_url:    nil,
  language:          language,
  audio:             language,
  subtitles:         language,
  published:         true,
  # reviewed:          false,
  stale:             false,
  alternate_course:  nil,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld
}

content[:rating] = { type: 'stars', value: rating, range: 5 } if rating.present?

content[:video] = video if video.present?

content[:slug] = [
  I18n.transliterate(content[:course_name]).downcase,
  Resource.digest(Zlib.crc32(content[:url]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.accumulator = {
  kind:           :course,
  schema_version: '1.0.0',
  unique_id:      Digest::SHA1.hexdigest(content[:url]),
  content:        content,
  relations:      Hash.new
}

call
