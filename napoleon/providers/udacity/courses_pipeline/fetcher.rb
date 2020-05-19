# get these values by looking for the section "../../libs/environments/src/lib/environment.constants.ts"
# on main-es5.[HASH].js on any course page
# these values will be scoped within js object CONTENTFUL_SPACES_PROD
CDN_CONTENTFUL_SPACE = '2y9b3o528xhq'
CDN_CONTENTFUL_TOKEN = 'd2c91acbd1d36c07181cbe1a427858a6b4be933445333705034195b4401dd17f'
FREE_COURSES_VIDEOS  = CSV.read(File.join(NapoleonApp.root,'providers','udacity','free_courses_videos.csv')).to_h

version   = '1.1.0'
url       = pipe_process.initial_accumulator[:url]
rating    = nil
node_key  = url.split('--').last

if node_key =~ /-ent\Z/
  raise Pipe::Error.new(:skipped, 'Enterprise course')
end

pace      = 'self_paced'
published = true

if pipe_process.initial_accumulator[:api]
  payload      = pipe_process.initial_accumulator[:api_payload]
  course_name  = payload[:title]
  offered_by   = payload[:affiliates].each_with_index.map{|affiliate, index| { name: affiliate[:name], type: 'company', distinguished: false, main: (index == 0) } }
  syllabus     = (payload[:program_syllabus][:lessons].map{|lesson| {title: lesson[:title], points: lesson[:points] }} rescue [])
  effort       = syllabus.count > 0 ? syllabus.count*2.0 : 20.0
  duration     = if payload[:expected_duration] && payload[:expected_duration_unit] && payload[:expected_duration] > 0
                   { value: payload[:expected_duration], unit: payload[:expected_duration_unit][-1] == "s" ? payload[:expected_duration_unit] : "#{payload[:expected_duration_unit]}s" }
                 elsif syllabus.count > 0
                  { value: syllabus.count, unit: 'lessons' }
                 else
                  { value: 3, unit: 'months' }
                 end
  workload       = { value: effort/duration[:value], unit: duration[:unit] }
  instructors  = payload[:instructors].each_with_index.map{|instructor, index| { name: instructor[:name], distinguished: false, main: (index == 0) } }
  requirements = payload[:required_knowledge]
  description  = payload[:summary]
  video        = case (video_url = payload.dig(:teaser_video, :youtube_url))
                 when /youtube.com/
                  uri = URI.parse(video_url)
                  id = uri.path.split('/').last
                  { type: 'youtube', id: id }
                 when /vimeo.com/
                  uri = URI.parse(video_url)
                  id = uri.path.split('/').last
                  { type: 'vimeo', id: id }
                 else
                  nil
                 end
  course_level = payload[:level] || 'beginner'
  course_type  = payload.dig(:metadata, :type)
  skills       = payload.dig(:metadata, :skills)
  free_content = true
  paid_content = !free_content
  certificate  = nil
  prices       = []
  extras       = {
    skills: skills,
    syllabus: syllabus,
    requirements: requirements,
    course_type: course_type
  }

  if video.nil? && (video_id = FREE_COURSES_VIDEOS[node_key])
    video = { type: 'youtube', id: video_id }
  end
else
  call

  status_code = pipe_process.accumulator[:status_code]
  raise Pipe::Error.new(:skipped, 'Course page does not exist') unless status_code == 200

  json_ld  = pipe_process.accumulator[:json_ld]&.first
  payload  = pipe_process.accumulator[:payload]
  headers  = pipe_process.accumulator[:response_headers]
  anon_id  = pipe_process.accumulator[:cookie_jar]&.select{|cookie| cookie[:name] == "ajs_anonymous_id"}&.map{|cookie| cookie[:value] }&.first&.match(/%22(.*)%22/)&.[](1)
  document = Nokogiri::HTML(payload)

  if document.css('.page-404').count > 0
    raise Pipe::Error.new(:skipped, 'Course page does not exist')
  end

  nanodegree = json_ld[:educationalCredentialAwarded] == "Udacity Nanodegree"

  if nanodegree
    contentful_slug = url.sub('https://www.udacity.com/course/','')
    uri = URI.parse("https://cdn.contentful.com/spaces/#{CDN_CONTENTFUL_SPACE}/environments/master/entries?include=10&select=fields%2Csys&locale=en-US&fields.slug=#{contentful_slug}&content_type=pageNdopV0")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{CDN_CONTENTFUL_TOKEN}"
      http.request(request) # Net::HTTPResponse object
    end

    if response && response.code == "200"
      contentful_json  = JSON.parse(response.body)
      contentful_props = contentful_json['includes']['Entry'].inject({}) do |acc, entry|
        existing = acc[entry['sys']['contentType']['sys']['id']]
        if existing
          if existing.is_a?(Array)
            existing << entry['fields']
          else
            acc[entry['sys']['contentType']['sys']['id']] = [ existing, entry['fields'] ]
          end
        else
          acc[entry['sys']['contentType']['sys']['id']] = entry['fields']
        end
        acc
      end

      if contentful_props.dig('ctaButtonsContainer','title') == 'We are not taking enrollments at this time'
        raise Pipe::Error.new(:skipped, 'Course is offline')
      end

      course_name      = contentful_props.dig('pageMetadata','title')
      description      = contentful_props.dig('pageMetadata','description')
      offered_by       = []
      instructors      = contentful_props.dig('instructor').presence && Array.wrap(contentful_props.dig('instructor')).each_with_index.map{|instructor, index| { name: instructor['instructorName'], distinguished: false, main: (index == 0) } }
      duration         = (time_to_complete = contentful_props.dig('term', 'timeToComplete')) && time_to_complete =~ /(?<value>([0-9]+))\s*(?<unit>([^\s]+))/ && { value: $1.to_i, unit: $2.downcase }
      workload_value   = contentful_props.dig('ndOverviewColumn')&.select{|oc| oc['name'] == "#{node_key}_Time" }&.first&.[]('footer')&.match(/(?<min>[0-9]+)\-(?<max>[0-9]+)\s*hrs\s*/)&.to_a&.last(2)&.map(&:to_i)&.sum&./(2)
      workload         = workload_value ? { value: workload_value, unit: 'hours' } : { value: 10, unit: 'hours' }
      effort           = duration[:value] * 4 * workload[:value]
      level            = contentful_props.dig('ndOverviewColumn')&.select{|oc| oc['name'] == "#{node_key}_Level" }&.first&.[]('featuredInfo')&.downcase || 'beginner'
      summary          = contentful_props.dig('term', 'summary')
      requirements     = contentful_props.dig('term', 'supplementalContent','detailedRequirementsModalContent')
      preparation      = contentful_props.dig('term', 'supplementalContent','preparation')
      syllabus         = contentful_props.dig('termPart')&.sort_by{|part| part['sectionName'].sub(/#{node_key}\s*-\s*Term\s*Part\s*/,'').to_i }&.map{|part| { title: part['title'], description: part['description'] } }
      pricing          = contentful_props.dig('degreePricing','installmentInfo') # subscriptionPricing
      term_id          = contentful_props.dig('priceCard', 'termId')
      certificate      = { type: 'included' }
      video_url        = contentful_props.dig('hero','trailerVideoUrl')
      video            = case video_url
                         when /youtube.com/
                          uri = URI.parse(video_url)
                          id = uri.path.split('/').last
                          { type: 'youtube', id: id }
                         when /vimeo.com/
                          uri = URI.parse(video_url)
                          id = uri.path.split('/').last
                          { type: 'vimeo', id: id }
                         else
                           nil
                         end
      extras            = {
        requirements: requirements,
        preparation: preparation,
        syllabus: syllabus
      }
    end

    uri = URI.parse("https://braavos.udacity.com/api/prices?item=urn:x-udacity:item:nd-unit:#{term_id}&price_sheet=regular&anonymous_id=#{anon_id}&currency=USD")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(request)
    end

    if response && response.code == "200"
      braavos_json = JSON.parse(response.body)
      upfront_recurring = braavos_json['results']&.first&.dig('payment_plans','upfront_recurring','upfront_amount','payable_amount')
      prices = upfront_recurring ? [
        {
          type: 'single_course',
          price: ('%.2f' % (upfront_recurring/100.0)),
          plan_type: 'regular',
          customer_type: 'individual',
          currency: 'USD'
        }
      ] : []
    end
  else
    raise Pipe::Error.new(:skipped, 'Course is neither Nanodegree nor Free')
  end
end

language     = video ? ['en'] : nil
audio        = video ? ['en'] : nil
subtitles    = video ? ['en'] : nil

if video && video[:type] == 'youtube'
  begin
    response = Net::HTTP.get(URI.parse("https://www.youtube.com/watch?v=#{video[:id]}"))
    captions = JSON.parse("{" + (response.scan(Regexp.new('\\\"captionTracks\\\":\[[^\]]+\]'))[0].gsub("\\\"","\"") rescue '') + "}")

    if captions['captionTracks']
      subtitles = captions['captionTracks'].map{|track| track['languageCode'] }
    end
  rescue
    nil
  end
end

if video && video[:type] == 'vimeo'
  begin
    response = Net::HTTP.get(URI.parse("https://player.vimeo.com/video/#{video[:id]}/config"))
    config = JSON.parse(response)

    if config['request'] && config['request']['text_tracks']
      subtitles = config['request']['text_tracks'].map{|track| track['lang']}
    end
  rescue
    nil
  end
end

slug = [
  I18n.transliterate(course_name).downcase,
  Resource.digest(Zlib.crc32(url))
].join('-').gsub(/[\s\_\-]+/, '-').gsub(/[^0-9a-z\-]/i, '').gsub(/(^\-)|(\-$)/, '')

content = {
  slug: slug,
  course_name: course_name,
  level: course_level,
  provider_name: 'Udacity',
  instructors: instructors,
  certificate: certificate,
  url: url,
  offered_by: offered_by,
  description: description,
  pace: pace,
  effort: effort,
  workload: workload,
  duration: duration,
  rating: rating,
  language: language,
  audio: language,
  subtitles: subtitles,
  prices: prices,
  published: published,
  extras: extras,
  video: video,
  version: version
}

pipe_process.accumulator = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}
