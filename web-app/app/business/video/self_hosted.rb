class Video::SelfHosted

  def self.call(params)
    signer = Aws::CloudFront::UrlSigner.new(
      key_pair_id: ENV['AWS_KEY_PAIR_ID'],
      private_key: ENV['AWS_PRIVATE_KEY'].gsub('\\n', "\n")
    )
    {
      url:           signer.signed_url(params.url, expires: 30.minutes.from_now),
      embed:         params.embed,
      thumbnail_url: params.thumbnail_url
    }
  end

end
