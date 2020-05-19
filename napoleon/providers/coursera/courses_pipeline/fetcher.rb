call

provider_types     = {  "CollegeOrUniversity" => 'university' }.tap{|h| h.default = 'other'}
level_types        = { 'BEGINNER' => 'beginner', 'INTERMEDIATE' => 'intermediate', 'ADVANCED' => 'advanced' }
date_rgx           = Regexp.new(["285c647b347d292d285c647b327d292d285c647b327d29"].pack("H*"))
js_prop_rgx        = Regexp.new(["77696e646f775c2e4170703d282e2a29"].pack("H*"))
apollo_pro_rgx     = proc { |course_id| Regexp.new(["2e2a257b636f757273655f69647d5c2e282e2a29"].pack('H*') % {course_id: course_id}) }
payload            = pipe_process.accumulator[:payload]
json_ld            = pipe_process.accumulator[:json_ld]&.first
document           = Nokogiri::HTML(payload)
graph              = json_ld&.[](:@graph)
product            = graph&.select{|node| node[:@type] == 'Product' }&.first
course             = graph&.select{|node| node[:@type] == 'Course' }&.first
courseInstance     = course&.[](:hasCourseInstance)
url                = course&.[](:url) || pipe_process.initial_accumulator[:url]
course_name        = course&.[](:name)
offered_by         = course&.[](:provider)&.each_with_index&.map{|provider, index| { type: provider_types[provider[:@type]], name:  provider[:name], main: (index == 0) } }
start_date         = courseInstance&.[](:startDate)&.gsub(date_rgx){ [$1,$2,$3].join('/') }
end_date           = courseInstance&.[](:endDate)&.gsub(date_rgx){ [$1,$2,$3].join('/') }
instructors        = courseInstance&.[](:instructor)&.each_with_index&.map{|instructor, index| { name: instructor[:name], distinguished: false, main: (index == 0) } }
description        = course&.[](:description)
pace               = 'self_paced' # session-based approximation
version            = '1.0.0'
ratingValue        = product&.dig(:aggregateRating, :ratingValue)&.to_f
rating             = { type: 'stars', value: ratingValue, range: 5 } if ratingValue
effort             = nil
level              = nil
video_id           = nil
first_lecture_url  = nil
coursera_id        = nil
primary_languages  = []
subtitle_languages = []
extras             = {}

jsPropertiesNode = document.css('script').select{|script_node| script_node.to_s =~ js_prop_rgx }[0]
if jsPropertiesNode
  jsProperties = jsPropertiesNode.text()
  windowV8     = V8::Context.new.eval("var window = {};"+jsProperties+"; window")
  from_v8_to_h = proc { |v8_context|
    v8_context.inject(Hash.new) do |h, (key, value)|
      v = value.class.name =~ /V8::/ ? from_v8_to_h.call(value) : value
      k = key.class.name =~ /V8::/ ? from_v8_to_h.call(key) : key
      h[k] = v
      h
    end
  }
  window           = from_v8_to_h.call(windowV8).tap{|h| h.delete('renderedClassNames') }
  apollo           = window&.[]('__APOLLO_STATE__')&.select{|k,v| k !~ /[dD]omainsV1/ }
  course_id        = apollo&.keys&.select{|k| k=~/COURSE~(.*).xdpMetadata/ }&.first&.[](/COURSE~(.*).xdpMetadata/,1)
  modules_info     = window.dig('App','context','dispatcher','stores','NaptimeStore','data')
  modules_ids      = modules_info&.[]('onDemandCourseMaterials.v2')
  modules_names    = modules_info&.[]('onDemandCourseMaterialModules.v1')&.map{|k, v| {name: v['name'], time_commitment: v['timeCommitment']}}
  effort           = modules_names&.map{|a| a[:time_commitment] }&.reduce(:+)&./(1000.0*60*60)
  effort         ||= course&.[](:timeRequired)&.match(/PT(?<hour>[0-9]+H)(?<minute>[0-9]+M)/){ $1.to_i + $2.to_i/60.0 }
  course_id      ||= modules_ids&.keys.first
  apollo_metadata  = apollo&.select{|k,v| k =~ Regexp.new("Metadata:"+course_id) }&.inject(Hash.new) do |h, (k,v)|
    h[k[apollo_pro_rgx.call(course_id),1] || "root"] = v
    h
  end

  coursera_id                 = apollo_metadata&.dig('root','id')
  coursera_slug               = apollo_metadata&.dig('root','slug')
  course_status               = apollo_metadata&.dig('root','courseStatus')
  avg_learning_hours_adjusted = apollo_metadata&.dig('root','avgLearningHoursAdjusted')
  course_level                = level_types[apollo_metadata&.dig('root','level')]
  certificates                = Array.wrap(apollo_metadata&.dig('root','certificates','json')&.keys).compact
  course_status               = apollo_metadata&.dig('root','courseStatus')
  domains                     = Array.wrap(apollo_metadata&.dig('root','domains')&.keys&.map{|h| apollo[h['id']]}&.map{|h| h['domainId']}).compact
  primary_languages           = Array.wrap(apollo_metadata&.dig('root','primaryLanguages','json')&.keys).compact
  skills                      = Array.wrap(apollo_metadata&.dig('root','skills','json')&.keys).compact
  subtitle_languages          = Array.wrap(apollo_metadata&.dig('root','subtitleLanguages','json')&.keys).compact
  first_lecture_item          = nil
  material                    = {
    'weeks' => (apollo[apollo_metadata&.dig('root','material')['id']]['weeks'].keys.map do |wk,wv|
      week = apollo[wk['id']]
      {
        'modules' => (week['modules'].keys.map do |mk,mv|
          mod       = apollo[mk['id']]
          m_id      = mod['id']
          m_name    = mod['name']
          m_desc    = mod['description']
          m_t_vid   = mod['totalVideos']
          m_t_qui   = mod['totalQuizzes']
          m_t_dur   = mod['totalDuration']
          m_t_lec   = mod['totalLectureDuration']
          m_t_rea   = mod['totalReadings']
          m_items   = (mod['items'].keys.map do |ik,iv|
            item       = apollo[ik['id']]
            i_id       = item['id']
            i_duration = item['duration']
            i_name     = item['name']
            i_type     = item['typeName']
            i_slug     = item['slug']

            if i_type == 'lecture'
              first_lecture_item ||= item
            end

            { 'id' => i_id, 'duration' => i_duration, 'name' => i_name, 'type' => i_type, 'slug' => i_slug }
          end)

          { 'id' => m_id, 'name' => m_name, 'description' => m_desc, 'total_videos' => m_t_vid, 'total_duration' => m_t_dur, 'total_lecture_duration' => m_t_lec, 'total_readings' => m_t_rea, 'items' => m_items}
        end)
      }
    end)
  }
  first_lecture_url  = if first_lecture_item
    ["https://www.coursera.org/lecture", coursera_slug, [first_lecture_item['slug'], first_lecture_item['id']].join('-') ].join('/')
  end

  video_id = if coursera_slug && first_lecture_item
    [coursera_slug,first_lecture_item['slug'],first_lecture_item['id']].join('-')
  end

  description ||= apollo_metadata.dig('root','description')
  instructors ||= apollo.values_at(*apollo_metadata.dig('root','instructors')&.keys&.map{|i| i['id'] }).each_with_index.map do |instructor, index|
    { name: instructor["fullName"], distinguished: false, main: (index == 0) }
  end
  offered_by  ||= apollo.values_at(*apollo_metadata.dig('root','partners')&.keys&.map{|p| p['id'] }).each_with_index.map do |partner, index|
    { type: provider_types[nil], name:  partner['name'], main: (index == 0) }
  end
  rating      ||= apollo&.select{|k,v| k=~ /courseDerivatives/i }&.values&.first&.each_pair&.inject({range: 5, type: 'stars'}){|h,(k,v)| h[:value] = v if k == 'averageFiveStarRating'; h }
  if rating && rating[:value].nil?
    rating = nil
  end
  course_name ||= apollo_metadata&.dig('root','name')

  slug          = if coursera_slug && url
    [coursera_slug.downcase,Resource.digest(Zlib.crc32(url))].join('-').gsub(/[[:blank:]_-]+/, '-').gsub(/[^0-9a-z-]/i, '').gsub(/(^-)|(-$)/, '')
  end

  extras = extras.merge({
    'coursera_id' => coursera_id,
    'coursera_slug' => coursera_slug,
    'course_status' => course_status,
    'avg_learning_hours_adjusted' => avg_learning_hours_adjusted,
    'course_level' => course_level,
    'certificates' => certificates,
    'domains' => domains,
    'primary_languages' => primary_languages,
    'skills' => skills,
    'subtitle_languages' => subtitle_languages,
    # 'material' => material,
    'first_lecture_url' => first_lecture_url
  })
end

content = {
  slug: slug,
  course_name: course_name,
  level: course_level || [],
  provider_name: 'Coursera',
  instructors: instructors,
  url: url,
  offered_by: offered_by,
  description: description,
  pace: pace,
  effort: effort,
  rating: rating,
  language: primary_languages,
  audio: primary_languages,
  subtitles: subtitle_languages,
  published: true,
  json_ld: json_ld,
  extras: extras,
  version: version
}

pipe_process.data = {
  content: content,
  first_lecture_url: first_lecture_url,
  course_id: coursera_id,
  video_id: video_id
}