class Video::SelfHosted

  def self.call(video_struct)
    signer = Aws::CloudFront::UrlSigner.new(
      key_pair_id: ENV['AWS_KEY_PAIR_ID'],
      private_key: ENV['AWS_PRIVATE_KEY'].gsub('\\n', "\n")
    )
    { url: signer.signed_url(video_struct.url, expires: 30.minutes.from_now), mode: 'html5' }
  end

end
