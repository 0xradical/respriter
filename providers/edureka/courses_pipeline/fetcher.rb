raise Pipe::Error.new(:skipped, 'Is not a Course') if pipe_process.accumulator[:url] == 'https://www.edureka.co/blog'

call

status_code = pipe_process.accumulator[:status_code]
raise "Something went wrong, got HTTP status #{status_code}" unless status_code == 200

json_ld  = pipe_process.accumulator[:json_ld]
payload  = pipe_process.accumulator[:payload]
headers  = pipe_process.accumulator[:response_headers]
document = Nokogiri::HTML(payload)

raise Pipe::Error.new(:skipped, 'Master Program') if document.css('.master_course_tabs').present?

raise Pipe::Error.new(:skipped, 'Missing JSON+LD') unless json_ld

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'
grouped_json_ld = json_ld.group_by{ |j| j[:@type].underscore.to_sym }

raise Pipe::Error.new(:skipped, 'Missing Course') unless grouped_json_ld[:course]
raise 'More than 1 course JSON+LD?' if grouped_json_ld[:course].size > 1

course_json_ld = grouped_json_ld[:course].first
raise Pipe::Error.new(:skipped, 'Nameless Course') unless course_json_ld[:name]

languages = [ course_json_ld[:hasCourseInstance][0][:inLanguage] ] rescue nil
# TODO: Handle courses without language
raise Pipe::Error.new(:skipped, 'Language Missing Course') unless languages

price_value = grouped_json_ld[:product]&.first&.[](:offers)&.[](:price) || course_json_ld[:hasCourseInstance]&.first&.[](:offers)&.[](:price)
free = price_value.nil?
raise Pipe::Error.new(:failed, 'Missing Price') if free

javascript_variables = Hash.new
if script_node = document.css('body script').find{ |node| Napoleon::JavaScript.new(node.text).has_variable? 'videoData' }
  js = Napoleon::JavaScript.new script_node.text
  javascript_variables = {
    course_id:                    js[:course_id],
    course_info:                  js[:courseinfo],
    video_data:                   js[:videoData],
    clp_batches:                  js[:clpBatches],
    course_category:              js[:courseCategory],
    clevertap_account_id_batches: js[:clevertapAccountId]
  }
else
  # TODO: Handle courses without JS Data
  raise Pipe::Error.new(:skipped, 'Missing JavaScript Data') if javascript_variables.blank?
end

first_duration = javascript_variables&.[](:clp_batches)&.[](0)&.[](:duration)
raise Pipe::Error.new(:failed, 'Missing First Duration') if first_duration.blank?

pace = effort = duration = workload = nil
if course_json_ld[:timeRequired].present?
  effort_regex = /R(?<duration>\d+(\.\d+)?)\/P\d+DT(?<workload>\d+)H/
  match = course_json_ld[:timeRequired].match(effort_regex)
  if match
    duration = { value: match[:duration].to_i, unit: 'weeks' }
    workload = { value: match[:workload].to_i, unit: 'weeks' }
    effort   = duration[:value] * workload[:value]
  else
    raise "Invalid Duration #{course_json_ld[:timeRequired]}"
  end
  pace = 'live_class'
else
  pace = 'instructor_paced'
end

rating = nil
if rating_value = course_json_ld&.[](:aggregateRating)&.[](:ratingValue)
  rating = { type: 'stars', value: rating_value, range: [1, 5] }
end

provided_category = grouped_json_ld[:breadcrumb_list]&.first&.[](:itemListElement)&.[](2)&.[](:item)&.[](:name)

syllabus = document.css('#Curriculum-accordian div.panel').map do |div|
  title = div.css('h3.panel-title').text
  body  = ReverseMarkdown.convert( div.css('div.panel-body').to_s )

  "# #{title}\n\n#{body}"
end

duration_regex = /(?<value>\d+)\s(?<unit>weeks|days)/i
currencies = [:usd, :eur, :cad, :gbp, :aud, :inr, :sgd]
enrollments = javascript_variables[:clp_batches].map do |batch|
  prices = currencies.map do |currency|
    discount_type = batch[:"discount_type_#{currency}"]

    if discount_type.present?
      raise "Unknown discount type code '#{discount_type}'" if discount_type != '1'
      {
        type:           'single_course',
        plan_type:      'regular',
        price:          batch[:"price_#{currency}"],
        original_price: batch[:"price_discount_#{currency}"].to_s,
        discount:       batch[:"discount_#{currency}"].to_s,
        currency:       currency.to_s.upcase
      }
    else
      {
        type:           'single_course',
        plan_type:      'regular',
        price:          batch[:"price_#{currency}"],
        original_price: batch[:"price_#{currency}"],
        currency:       currency.to_s.upcase
      }
    end
  end
  id          = batch[:batch_id].to_s
  start_at    = batch[:start_date].gsub('-', '/')
  end_at      = batch[:end_date].gsub('-', '/')
  valid_until = batch[:valid_till].gsub('-', '/') rescue nil

  batch_duration = batch_workload = nil
  if duration_match = batch[:duration].match(duration_regex)
    batch_duration = {
      value: duration_match[:value].to_i,
      unit:  duration_match[:unit].downcase
    }
    if effort
      batch_workload = {
        value: effort / batch_duration[:value],
        unit: 'hours'
      }
    end
  end

  {
    id:          id,
    prices:      prices,
    start_at:    start_at,
    end_at:      end_at,
    duration:    batch_duration,
    workload:    batch_workload,
    valid_until: valid_until
  }
end

prices = enrollments.group_by do |enrollment|
  enrollment[:prices]
end.map do |grouped_prices, batches|
  grouped_prices.map do |currency_price|
    currency_price.merge enrollment_ids: batches.map{ |batch| batch[:id] }
  end
end.flatten.sort_by do |price|
  [
    currencies.index(price[:currency].downcase.to_sym),
    price[:price].to_f
  ]
end

video = nil
youtube_regex         = /www\.youtube\.com\/watch\?v\=(?<id>.+)/
wistia_iframe_regexp  = /https\:\/\/fast\.wistia\.(com|net)\/embed\/iframe\/(.*)/
edureka_wistia_regexp = /https\:\/\/edureka\.wistia\.(com|net)\/medias\/(.*)/
video_url = javascript_variables&.[](:video_data)&.[](:url)
if video_url
  if match = video_url.match(youtube_regex)
    video = {
      type: 'youtube',
      id: match[:id]
    }
  else
    video_id = video_url.match(wistia_iframe_regexp)&.[](2) || video_url.match(edureka_wistia_regexp)&.[](2) || binding.pry

    video_url     = "https://fast.wistia.com/embed/iframe/#{video_id}"
    thumbnail_url = "https://fast.wistia.com/embed/medias/#{video_id}"

    video = {
      type:          'raw',
      url:           video_url,
      thumbnail_url: thumbnail_url,
      provider:      'wistia',
      embed:         true
    }
  end
end

content = {
  version:           '1.1.0',
  url:               course_json_ld[:@id],
  course_name:       course_json_ld[:name],
  paid_content:      !free,
  free_content:      free,
  provider_name:     'Edureka',
  description:       course_json_ld[:description],
  prices:            prices,
  level:             [],
  language:          languages,
  audio:             languages,
  subtitles:         languages,
  status:            'available',
  provided_category: provided_category,
  # tags:              provided_tags,
  provided_tags:     [ provided_category ],
  video:             video,
  syllabus:          syllabus,
  pace:              pace,
  # instructors:       nil,
  # offered_by:        [],
  certificate:       { type: 'included' },
  extra_content:     nil,
  duration:          duration,
  workload:          workload,
  effort:            effort,
  published:         true,
  stale:             false,
  rating:            rating,
  aggregator_url:    nil,
  enrollments:       enrollments,
  last_fecthed_at:   last_fecthed_at,
  json_ld:           json_ld,
  extra: {
    javascript_variables: javascript_variables
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
