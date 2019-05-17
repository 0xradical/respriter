class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  def store_dir
    Rails.env.production? ? 'uploads/' : Rails.root.join('tmp', 'uploads')
  end

  version :sm do
    process resize_to_limit: [64,64]
  end

  version :xs do
    process resize_to_limit: [32,32]
  end

  def serializable_hash
    super.tap { |h| h[:path] = self.path }
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def md5
    @md5 ||= Digest::MD5.hexdigest model.send(mounted_as).read.to_s
  end

  def filename
    @name ||= "#{File.basename(file.original_filename, '.*')}-#{md5}#{File.extname(super)}" if super
  end

  protected

  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

  def imageable
    model.imageable
  end

  def imageable_name
    imageable.class.to_s.underscore
  end

  def timestamp_to_base36
    (Time.now.to_f * 1000).to_i.to_s(36)
  end

end
