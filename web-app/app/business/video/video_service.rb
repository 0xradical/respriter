class Video::VideoService

  def self.call(params)
    url = "#{ video_url params.path }?#{ signed_query_params params.path }"
    {
      url:           url,
      embed:         params.embed,
      thumbnail_url: params.thumbnail_url
    }
  end

  def self.video_url(path)
    [ ENV['VIDEO_SERVICE_HOST'], path ].join('/')
  end

  def self.signed_query_params(path)
    query_string = "date=#{Time.now.to_i}"
    query_string + '&token=' + sign("[GET]/#{path}?#{query_string}")
  end

  def self.sign(payload)
    OpenSSL::HMAC.hexdigest 'SHA1', ENV['VIDEO_SERVICE_KEY'], payload
  end
end
