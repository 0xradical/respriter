class Video::Brightcove

  def self.call(video_struct)
    { url: video_struct.url, mode: 'iframe' }
  end

end

