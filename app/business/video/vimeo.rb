class Video::Vimeo
  def self.call(params)
    {
      url:           "//player.vimeo.com/video/#{params.id}",
      thumbnail_url: thumbnail_url(params),
      embed:         true
    }
  end

  def self.thumbnail_url(params)
    return params.thumbnail_url if params.thumbnail_url
    [ ENV['VIDEO_SERVICE_HOST'], 'vimeo/thumbnail', params.id ].join('/')
  end
end
