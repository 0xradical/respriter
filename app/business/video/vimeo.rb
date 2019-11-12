class Video::Vimeo
  def self.call(video_struct)
    { url: "//player.vimeo.com/video/#{video_struct.id}", embed: true }
  end
end
