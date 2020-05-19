new_accumulator   = pipe_process.data
pipe_process.data = nil

if pipe_process.accumulator && pipe_process.accumulator[:url]
  call

  if pipe_process.accumulator[:status_code] == 200
    payload   = Oj.load pipe_process.accumulator[:payload]
    video_url = payload['sources'].select do |s|
      s['container'] == 'MP4'  &&
      s['codec']     == 'H264' &&
      s['src']                 &&
      s['src'].match(/\Ahttps?/)
    end.max_by{ |s| s['avg_bitrate'] }&.[]('src')

    new_accumulator[:content][:extra][:video_payload] = payload

    unless video_url.present?
      new_accumulator[:content][:video] = nil
    end
  else
    new_accumulator[:content][:video] = nil
  end
end

pipe_process.accumulator = new_accumulator
