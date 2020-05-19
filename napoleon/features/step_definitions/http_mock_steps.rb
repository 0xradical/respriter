Given /^a (get|post|put|patch) route that responds to (https?:\/\/.*)$/ do |method, url|
  @stubbed_request = stub_request method.to_sym, url
end

Given /^redirects to (https?:\/\/.*) after (\d+) leaps with$/ do |redirected_url, leaps, evaluable_data|
  first_intermediary = leaps > 1 ? "https://intermediary1.com" : redirected_url
  @stubbed_request   = @stubbed_request.to_return(status: 301, headers: { location: first_intermediary })

  0.upto([0, leaps - 1].max) do |leap|
    stub_request(:get, "https://intermediary#{leap}.com").to_return(status: 301, headers: { location: (leap == leaps - 1) ?  redirected_url : "https://intermediary#{leap+1}.com" })
  end

  stub_request(:get, redirected_url).to_return eval(evaluable_data)
end

Given /^with HTTP headers$/ do |table|
  headers = table.hashes.first.symbolize_keys
  @stubbed_request = @stubbed_request.with headers: headers
end

Given /^returning an HTTP response with$/ do |evaluable_data|
  @stubbed_request = @stubbed_request.to_return eval(evaluable_data)
end

Given /^returning an HTTP response with a huge video$/ do
  uuid       = SecureRandom.uuid
  multiplier = 10000
  huge_video = uuid * multiplier

  sha1 = Digest::SHA1.new
  multiplier.times{ sha1.update uuid }
  @huge_video_hash = sha1.hexdigest

  @stubbed_request = @stubbed_request.to_return headers: { 'Content-Length': huge_video.size }, body: huge_video
end

Given /^a random pattern repeated (\d+) times$/ do |count|
  @random_pattern = SecureRandom.hex
  sha1 = Digest::SHA1.new
  count.to_i.times{ sha1.update @random_pattern }
  @random_pattern_hash = sha1.hexdigest
end

Then /^page (.*) was( not)? requested$/ do |url, maybe_not|
  if maybe_not.present?
    expect(WebMock).to_not have_requested :get, url
  else
    expect(WebMock).to have_requested :get, url
  end
end

Then /^(signed )?(https?:\/\/.*) contains same random pattern repeated many times$/ do |*args|
  signed, video_url = args

  if signed.present?
    signer = Aws::Sigv4::Signer.new(
      region:            Napoleon.config.aws[:s3][:region],
      service:           's3',
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
    video_url = signer.presign_url(
      url:         video_url,
      expires_in:  432000,
      http_method: 'GET',
      body_digest: 'UNSIGNED-PAYLOAD'
    )
  end

  uri  = URI(video_url)
  sha1 = Digest::SHA1.new

  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new uri

    http.request request do |response|
      response.read_body do |chunk|
        sha1.update chunk
      end
    end
  end

  expect(sha1.hexdigest).to eq @random_pattern_hash
end
