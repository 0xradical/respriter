class Video::CourseraHosted

  def self.call(params)
    {
      url:           "#{params.url}full/540p/index.mp4",
      embed:         params.embed,
      thumbnail_url: params.thumbnail_url
    }
  end

end
