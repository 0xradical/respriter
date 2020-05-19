content = pipe_process.data[:content]

document = Nokogiri::HTML.fragment pipe_process.accumulator[:payload]

content[:extra][:syllabus_raw] = document.css('.new-modules--modules li.new-modules--scorm').map do |node|
  {
    title:     node.css('h3').map(&:text),
    subtitles: node.css('div.new-modules--topics a h4').map(&:text)
  }
end

content[:syllabus] = content[:extra][:syllabus_raw].map do |section|
  %{
    # #{ section[:title] }

    #{ section[:subtitles].map{ |t| "* #{t}" }.join "\n" }
  }
end.join "\n\n"

if duration_info = pipe_process.data[:content][:extra][:course_brief].to_h['Duration']
  lessons_count = document.css('.new-modules--modules li.new-modules--scorm div.new-modules--topics a h4').count

  content[:effort]   = duration_info.match(/(\d+\-)?(\d+) Hours/)[2].to_i
  content[:duration] = { value: lessons_count, unit: 'lessons' }
  content[:workload] = { value: (content[:effort]*60.0/lessons_count).ceil, unit: 'minutes' }
end

if level = content[:extra][:course_banner_info][2][1].match(/(Level|Livello|Niveau|Nivel|Nvel)\s+(\d)\s+$/)
  content[:level] = case level[2].to_i
  when 1
    'beginner'
  when 2
    'intermediate'
  when 3
    'advanced'
  end
end

content[:certificate] = { type: 'paid' }

pipe_process.accumulator = pipe_process.data
pipe_process.data = {
  alternate_course_url: content[:extra][:alternate_course_url]
}

call
