CarrierWave.configure do |config|
  config.enable_processing    = Rails.env.production?
  config.storage              = Rails.env.production? ? :aws : :file
  config.aws_bucket           = ENV['AWS_S3_BUCKET_NAME']
  config.aws_acl              = :public_read
  config.aws_credentials      = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_S3_REGION']
  }
  config.aws_attributes       = {
    cache_control: 'max-age=315576000',
    expires: 1.year.from_now.httpdate
  }
end
