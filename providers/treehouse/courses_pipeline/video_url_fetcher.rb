if !pipe_process.data[:skip_video]
  content    = pipe_process.data[:content]
  is_trailer = pipe_process.accumulator[:trailer]

  call
  payload   = pipe_process.accumulator[:payload]
  document  = Nokogiri::HTML(payload)

  video_url = nil
  video_id  = content[:slug].gsub('treehouse-','')

  if is_trailer
    video_url = document.css("source[type='video/mp4']")&.attribute('src')&.text
  else
    video_url = document.css('video source').select{|source| source.attribute('type').text() == 'video/mp4' }.first&.attribute('src')&.value
  end

  if video_url
    pipe_process.accumulator[:video_url] = video_url
    pipe_process.accumulator[:folder]    = 'treehouse'
    pipe_process.accumulator[:path]      = video_id.to_s + ".mp4"
    pipe_process.data[:skip_video]       = false
  else
    pipe_process.data[:skip_video]       = true
  end
end