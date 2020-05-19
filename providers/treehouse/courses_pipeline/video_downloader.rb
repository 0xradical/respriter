content = pipe_process.data[:content]

if !pipe_process.data[:skip_video]
  call

  content[:video] = { type: 'self_hosted', url: pipe_process.accumulator[:video_url] }
  pipe_process.accumulator[:validator] = {
    fields: [
      [:video, format: true, presence: true],
      [:subtitles, format: true, presence: true]
    ]
  }
end

pipe_process.accumulator = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}
