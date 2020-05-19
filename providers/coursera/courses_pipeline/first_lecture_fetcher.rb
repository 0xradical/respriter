if (first_lecture_url = pipe_process.data[:first_lecture_url]) && !pipe_process.data[:skip_video]
  pipe_process.accumulator[:url] = first_lecture_url

  call

  if pipe_process.accumulator[:status_code] == 404
    pipe_process.data[:skip_video] = true
  else
    js_prop_rgx      = Regexp.new(["77696e646f775c2e4170703d282e2a29"].pack("H*"))
    payload          = pipe_process.accumulator[:payload]
    document         = Nokogiri::HTML(payload)
    video_id         = pipe_process.data[:video_id]
    jsPropertiesNode = document.css('script').select{|script_node| script_node.to_s =~ js_prop_rgx }[0]

    pipe_process.data[:skip_video] = true

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
      modules_info     = window.dig('App','context','dispatcher','stores','NaptimeStore','data')
      videoSources     = modules_info&.[]("onDemandVideos.v1")&.first&.[](1)&.[]('sources')
      video_url        = videoSources&.dig('byResolution','720p','mp4VideoUrl') ||
                         videoSources&.dig('byResolution','540p','mp4VideoUrl') ||
                         videoSources&.dig('byResolution','360p','mp4VideoUrl')

      pipe_process.accumulator = Hash.new
      if video_url
        pipe_process.accumulator[:video_url] = video_url
        pipe_process.accumulator[:folder]    = 'coursera'
        pipe_process.accumulator[:path]      = video_id.to_s + ".mp4"
        pipe_process.data[:skip_video]       = false
      end
    end
  end
end
