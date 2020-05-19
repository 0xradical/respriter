url  = pipe_process.accumulator[:url]
data = pipe_process.accumulator[:data]

json_ld = data[:json_ld].first

instructors = [:data_objects].map do |object|
  next nil if object['author'].blank?
  object['author']
end.compact.uniq.map do |author_name|
  { name: author_name, distinguished: false, main: true }
end

description = nil

if json_ld[:description].present?
  description = json_ld[:description]
end

if description.blank? && data[:sitemap][:data_objects][0][:description].present?
  description = data[:sitemap][:data_objects][0][:description]
end

languages = data[:sitemap][:langs].keys

chapters = data[:chapters].map do |chapter|
  {
    title: chapter[:title],
    sub_chapters: chapter[:sub_chapters].map do |sub_chapter|
      s_chapter = sub_chapter[:sub_chapter]
      video_url = s_chapter&.[](:video)&.[](:player_loc)
      video_url = nil if video_url.blank? || video_url.strip.underscore == 'none'
      thumbnail = s_chapter&.[](:video)&.[](:thumbnail_loc)
      thumbnail = nil if video_url.blank? || video_url.strip.underscore == 'none'

      {
        title:       ( s_chapter&.[](:video)&.[](:title) || s_chapter&.[](:data_objects)&.first&.[](:title) ),
        type:        ( s_chapter&.[](:data_objects)&.first&.[](:type) ),
        duration:    ( s_chapter&.[](:video)&.[](:duration)&.to_i || 300 ),
        description: ( s_chapter&.[](:video)&.[](:description) || s_chapter&.[](:data_objects)&.first&.[](:description) ),
        video_url:   video_url,
        thumbnail:   thumbnail
      }
    end
  }
end

lessons = chapters.map do |chapter|
  chapter[:sub_chapters].size
end.sum

effort = chapters.map do |chapter|
  chapter[:sub_chapters].map do |sub_chapter|
    sub_chapter[:duration]
  end.sum
end.sum

syllabus = chapters.map do |chapter|
  "# #{chapter[:title]}\n\n#{ chapter[:sub_chapters].select{ |s| s[:title].present? }.map{ |s| "* #{s[:title]}" }.uniq.join("\n") }"
end.join "\n\n"

videos = chapters.map do |chapter|
  chapter[:sub_chapters].map do |sub_chapter|
    if sub_chapter.values_at(:video_url, :thumbnail).all?(&:present?)
      sub_chapter.slice :video_url, :thumbnail
    end
  end.compact
end.flatten

content = {
  provider_name:     'Khan Academy',
  course_name:       json_ld[:name],
  version:           '1.1.0',
  status:            'available',
  # level:             nil,
  url:               url,
  instructors:       instructors,
  offered_by:        [],
  start_date:        nil,
  end_date:          nil,
  enrollment_urls:   nil,
  prices:            [],
  certificate:       false,
  extra_content:     false,
  free_content:      true,
  paid_content:      false,
  # category:          nil,
  # tags:              nil,
  provided_tags:     nil,
  provided_category: nil,
  description:       description,
  syllabus:          syllabus,
  pace:              'self_paced',
  aggregator_url:    nil,
  rating:            nil,
  language:          languages,
  audio:             languages,
  subtitles:         languages,
  published:         true,
  # # reviewed:          false,
  stale:             false,
  video:             { type: 'raw', url: videos&.first&.[](:video_url), thumbnail_url: videos&.first&.[](:thumbnail), provider: 'khan_academy' },
  alternate_course:  nil,
  extra: { chapters: chapters },
  json_ld:           json_ld
}

if lessons > 0
  content.merge!(
    duration: { value: lessons,        unit: 'lessons' },
    workload: { value: effort/lessons, unit: 'seconds' },
    effort:   (effort / 3600.0).round
  )
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
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}

call
