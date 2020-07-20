course_data = pipe_process.data
payload, json_ld, headers = pipe_process.accumulator.values_at :payload, :json_ld, :response_headers

document = Nokogiri::HTML.fragment payload
contents = []

category_map = {
  "Business & Management"        => 'business',
  "Creative Arts & Media"        => 'arts_and_design',
  "Healthcare & Medicine"        => 'health_and_fitness',
  "History"                      => 'social_sciences',
  "IT & Computer Science"        => 'computer_science',
  "Language"                     => 'language_and_communication',
  "Law"                          => 'social_sciences',
  "Literature"                   => 'social_sciences',
  "Nature & Environment"         => 'life_sciences',
  "Politics & Society"           => 'social_sciences',
  "Psychology & Mental Health"   => 'health_and_fitness',
  "Science, Engineering & Maths" => 'math_and_logic',
  "Study Skills"                 => 'math_and_logic',
  "Teaching"                     => 'language_and_communication'
}

description = %{# Introduction

#{ ReverseMarkdown.convert course_data[:introduction] }

# Content

#{ ReverseMarkdown.convert course_data[:description] }
}

script_tag = document.css('script').find do |script_tag|
  script_tag.text.match(/\s+gtmDataLayer\s+\=\s+\[/)
end

unless script_tag.present?
  raise Pipe::Error.new(:failed, 'Missing Google Tag Manager Script where we scrape price')
end

google_tag_manager_data = JSON.parse script_tag.text.chomp.gsub(/\A\s+gtmDataLayer\s+\=\s+/,'').gsub(/\;\Z/, '')

paid_product_names = [
  'PaidForAccess',
  'Upgrade'
]
products     = google_tag_manager_data.last['ecommerce']['checkout']['products'] rescue []
free_content = products.any?{ |product| product['name'] == 'FreeJoinUpgradeEnrolment' }
paid_content = products.any?{ |product| product['name'] == 'PaidForAccess'            }

prices = []
if paid_content
  single_course = products.find{ |product| product['name'] == 'PaidForAccess' }
  if single_course.present?
    prices << {
      type:     'single_course',
      price:    single_course['price'],
      currency: 'USD'
    }
  end

  subscription_course = products.find{ |product| product['name'] == 'Unlimited' }
  if subscription_course.present?
    prices << {
      type:        'subscription',
      price:       subscription_course['price'],
      total_price: subscription_course['price'],
      currency:    'USD',
      subscription_period: {
        unit: 'years',
        value: 1
      },
      payment_period: {
        unit: 'years',
        value: 1
      }
    }
  end
end

certificate = nil
if course_data[:has_certificates] && course_data[:open_for_enrolment]
  upgrade = products.find{ |product| product['name'] == 'Upgrade' }
  if upgrade.present?
    certificate = {
      type:     'paid',
      price:    upgrade['price'],
      currency: 'USD'
    }
  else
    certificate = { type: 'included' }
  end
end

video = nil
if course_data[:trailer]
  video = {
    url:           "https:#{course_data[:trailer]}",
    type:          'raw',
    thumbnail_url: course_data[:image_url]
  }
end

category = nil
if course_data[:categories].present? && category_map[ course_data[:categories].first ]
  category = category_map[ course_data[:categories].first ]
end

instructors = []
if course_data[:educator].present?
  instructors = [{
    name: course_data[:educator],
    main: true
  }]
end

offered_by = []
if course_data[:organisation].present?
  organisation = course_data[:organisation]

  offered_by = [{
    id:       organisation[:uuid],
    name:     organisation[:name],
    url:      organisation[:url],
    logo_url: organisation[:logo_url],
    type:     'university',
    main:     true
  }]
end

effort = duration = workload = nil
begin
  duration = { value: course_data[:runs].first[:duration_in_weeks], unit: 'weeks' }
  workload = { value: course_data[:hours_per_week],                 unit: 'hours' }
  effort   = duration[:value] * workload[:value]
rescue
  effort = duration = workload = nil
end

content = {
  id:                  course_data[:uuid],
  url:                 course_data[:url].gsub(/\?.*/, ''),
  course_name:         course_data[:name],
  pace:                'instructor_paced',
  description:         description,

  language:            [ course_data[:language] ],
  audio:               [ course_data[:language] ],
  subtitles:           [ course_data[:language] ],

  category:            category,
  provided_categories: course_data[:categories],

  free_content:        free_content,
  paid_content:        paid_content,

  instructors:         instructors,
  offered_by:          offered_by,

  provider_id:         21,
  provider_name:       'FutureLearn',
  published:           course_data[:open_for_enrolment],
  stale:               false,
  json_ld:             json_ld,
  last_fecthed_at:     DateTime.parse(headers[:date]).strftime('%Y/%m/%d'),
  extra:               { course_data: course_data }
}

if effort.present? && duration.present? && workload.present?
  content[:effort]   = effort
  content[:duration] = duration
  content[:workload] = workload
end

content[:video]       = video       if video.present?
content[:prices]      = prices      if prices.present?
content[:certificate] = certificate if certificate.present?

content[:slug] = [
  I18n.transliterate( content[:course_name].to_s ).downcase,
  Resource.digest( Zlib.crc32(content[:id].to_s) )
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.accumulator = {
  kind:           'course',
  schema_version: '1.0.0',
  unique_id:      Digest::SHA1.hexdigest("future_learn/#{course_data[:uuid]}"),
  content:        content,
  relations:      Hash.new
}

call
