class Video::CourseraHosted

  def self.call(video_struct)
    { url: "#{video_struct.url}full/540p/index.mp4", mode: 'html5' }
  end

end
