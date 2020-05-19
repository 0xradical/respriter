content = pipe_process.data[:content]

if pipe_process.data[:first_lecture_url] && !pipe_process.data[:skip_video]
  call

  thumbnail_url = nil
  if content[:json_ld] && content[:json_ld][:@graph]
    thumbnail_url = content[:json_ld][:@graph].find{ |j| j[:@type] == 'Course' && j.has_key?(:image) }&.[](:image)
  end

  content[:video] = {
    url:           pipe_process.accumulator[:video_url],
    type:          'self_hosted',
    thumbnail_url: thumbnail_url
  }
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