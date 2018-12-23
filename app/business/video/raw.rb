class Video::Raw

  def self.call(video_struct)
    { url: video_struct.url, mode: 'html5' }
  end

end
