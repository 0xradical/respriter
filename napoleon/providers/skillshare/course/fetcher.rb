call

json_ld = pipe_process.accumulator[:json_ld]

if pipe_process.accumulator[:status_code] == 400
  raise Pipe::Error.new(:skipped, 'Skillshare bug')
end

if pipe_process.accumulator[:redirected] || json_ld.blank?
  if pipe_process.accumulator[:original_url].strip.present?
    query = ApplicationRecord.sanitize_sql [
      %{
        UPDATE app.resources
        SET content = jsonb_set(content, '{stale}', 'true'::jsonb)
        WHERE
          content->>'url'   = ?       AND
          content->>'stale' = 'false' AND
          kind              = 'course';
      },
      pipe_process.accumulator[:original_url].strip
    ]

    ApplicationRecord.connection.execute query
  end
  raise Pipe::Error.new(:skipped, 'Outdated Course')
else
  payload  = pipe_process.accumulator[:payload]
  headers  = pipe_process.accumulator[:response_headers]
  document = Nokogiri::HTML(payload)

  free     = false
  language = [ 'en', 'en-US' ]

  last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

  content_variable_pattern = /SS.serverBootstrap =\s*([^\n]+)\s*;\n/

  content_data = nil
  document.css('head script[type="text/javascript"]').each do |node|
    if match = node.text.match(content_variable_pattern)
      content_data = Oj.load(match[1]).deep_symbolize_keys
      break
    end
  end
  premium = content_data.try(:[], :classData).try(:[], :parentClass).try(:[], :is_premium)
  premium ||= premium.nil?

  level_tag = document.css('ul.level li[class="active"][data-value]').first
  level = case( level_tag && level_tag.attribute('data-value') )
  when '1'
    'beginner'
  when '2'
    'intermediate'
  when '3'
    'advanced'
  when '5'
    'beginner'
  when '6'
    'intermediate'
  end

  tags = document.css('.tags-section a[data-ss-tag]').map{ |n| n.attribute('data-ss-tag').text.strip }

  syllabus = nil
  lessons  = nil
  workload = nil
  lessons  = nil
  if video_list = document.css('ul.session-list.populated').first
    lessons_size = video_list.css('li.session-item').size
    lessons = "#{ lessons_size }L"
    seconds = video_list.css('li.session-item .duration').inject(0) do |sum, div|
      match = div.text.match(/(?<minutes>\d+):(?<seconds>\d+)/)
      sum + 60*match[:minutes].to_i + match[:seconds].to_i
    end
    workload = "#{seconds / lessons_size}s"
    effort   = seconds / (60*60)

    syllabus = video_list.css('p.session-item-title').map do |p|
      "# #{p.text}"
    end.join "\n\n"
  end

  offered_by = []
  if instructor = document.css('div.author-detail h4 a.link-main.no-bold.ellipsis').first
    offered_by << { type: 'instructor', name: instructor.text.strip, distinguished: false, main: true }
  end

  video_id         = nil
  video_account_id = nil
  begin
    video_id         = content_data[:pageData][:unitsData][:units][0][:sessions][0][:videoId].match(/bc\:/).post_match
    video_account_id = content_data[:pageData][:videoPlayerData][:brightcoveAccountId]
  rescue
  end

  content = {
    provider_name:     'Skillshare',
    course_name:       json_ld[0][0][:name],
    version:           '1.0.0',
    status:            'available',
    level:             level,
    url:               json_ld[0][0][:@id],
    offered_by:        offered_by,
    start_date:        nil,
    end_date:          nil,
    enrollment_urls:   nil,
    price:             15.0,
    currency:          'USD',
    price_details:     'monthly subscription',
    prices:            pipeline.data[:prices],
    certificate:       false,
    extra_content:     nil,
    paid_content:      premium,
    free_content:      !premium,
    # category:          nil,
    # tags:              nil,
    provided_tags:     tags,
    provided_category: nil,
    description:       json_ld[0][0][:description],
    syllabus:          syllabus,
    pace:              'self_paced',
    duration:          lessons,
    workload:          workload,
    effort:            lessons,
    aggregator_url:    nil,
    rating:            nil,
    language:          language,
    audio:             language,
    subtitles:         language,
    published:         true,
    # reviewed:          false,
    stale:             false,
    alternate_course:  nil,
    last_fecthed_at:   last_fecthed_at,
    json_ld:           json_ld,
    extra: {
      pipeline_execution: pipe_process.pipeline.pipeline_execution_id,
      class_id:           content_data[:classData][:id],
      sku:                content_data[:classData][:sku],
      video: {
        account_id: video_account_id,
        player_id:  content_data[:pageData][:videoPlayerData][:brightcovePlayerId],
        video_id:   video_id
      }
    }
  }

  content[:slug] = [
    I18n.transliterate(content[:course_name]).downcase,
    Resource.digest(Zlib.crc32(content[:extra][:class_id].to_s))
  ].join('-')
    .gsub(/[\s\_\-]+/, '-')
    .gsub(/[^0-9a-z\-]/i, '')
    .gsub(/(^\-)|(\-$)/, '')

  pipe_process.data = {
    kind:      :course,
    unique_id: Digest::SHA1.hexdigest("skillshare-#{content[:extra][:class_id]}"),
    content:   content,
    relations: Hash.new
  }

  if video_id && video_account_id
    pipe_process.accumulator = {
      url: "https://edge.api.brightcove.com/playback/v1/accounts/#{video_account_id}/videos/#{video_id}",
      http: {
        headers: { referer: content[:url] }
      }
    }

    content[:video] = {
      type:          'video_service',
      path:          "skillshare/#{video_account_id}/#{video_id}",
      thumbnail_url: json_ld[0][0][:image]
    }
  else
    pipe_process.accumulator = nil
  end
end
