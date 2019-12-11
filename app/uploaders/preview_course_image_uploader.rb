class PreviewCourseImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  aws_acl 'private'
  aws_authenticated_url_expiration (60 * 60 * 24 * 7)

  def store_dir
    "unsigned"
  end

  def serializable_hash
    super.tap { |h| h[:path] = self.path }
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def md5
    @md5 ||= Digest::MD5.hexdigest model.send(mounted_as).read.to_s
  end

  def filename
    @name ||= "preview_course__#{File.basename(original_filename, '.*')}-#{md5}#{File.extname(super)}" if super
  end
end
