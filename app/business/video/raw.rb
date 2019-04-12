class Video::Raw

  def self.call(video_struct)
    { url: video_struct.url, embed: video_struct.embed }
  end

end
