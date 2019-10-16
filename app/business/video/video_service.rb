class Video::VideoService

  def self.call(params)
    url = "#{video_url params.provider, params.id}?#{signed_query_params params.provider, params.id}"
    { url: signed(url), embed: params.embed }
  end

  def self.video_url(provider, id)
    [
      ENV['VIDEO_SERVICE_HOST'],
      video_struct.provider,
      video_struct.id
    ].join('/')
  end

  def self.signed_query_params(provider, id)
    query_string = "date=#{Time.now.to_i}"
    query_string + sign("[GET]/#{provider}/#{id}?#{query_string}")
  end

  def self.sign(payload)
    OpenSSL::HMAC.hexdigest 'SHA1', ENV['VIDEO_SERVICE_KEY'], payload
  end
end
