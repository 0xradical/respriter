CarrierWave.configure do |config|
  config.storage           = :aws
  config.aws_acl           = :public_read
  config.aws_bucket        = ENV.fetch 'AWS_S3_BUCKET_NAME'
  config.asset_host        = ENV.fetch 'AWS_S3_ASSET_HOST'
  config.enable_processing = Rails.env.production?

  config.aws_credentials = {
    endpoint:          ENV.fetch('AWS_S3_ENDPOINT'),
    access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    region:            ENV.fetch('AWS_S3_REGION'),
    force_path_style:  !Rails.env.production?
  }

  config.aws_attributes = {
    cache_control: 'max-age=315576000',
    expires:       1.year.from_now.httpdate
  }

end
