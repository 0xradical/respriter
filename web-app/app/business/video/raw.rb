class Video::Raw

  def self.call(params)
    {
      url:           params.url,
      embed:         params.embed,
      thumbnail_url: params.thumbnail_url
    }
  end

end
