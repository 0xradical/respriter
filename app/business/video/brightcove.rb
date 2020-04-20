class Video::Brightcove

  def self.call(params)
    {
      url:           params.url,
      embed:         true,
      thumbnail_url: params.thumbnail_url
    }
  end

end

