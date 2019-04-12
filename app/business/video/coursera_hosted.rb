class Video::CourseraHosted

  def self.call(video_struct)
    { url: "#{video_struct.url}full/540p/index.mp4", embed: video_struct.embed }
  end

end
