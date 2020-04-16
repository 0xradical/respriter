class Video::Vimeo
  def self.call(params)
    {
      url:           "//player.vimeo.com/video/#{params.id}",
      thumbnail_url: params.thumbnail_url,
      embed:         true
    }
  end
end
