class Video::Brightcove

  def self.call(video_struct)
    { url: video_struct.url, embed: true }
  end

end

