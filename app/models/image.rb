class Image < ApplicationRecord

  belongs_to :imageable, polymorphic: true
  mount_uploader :file, ImageUploader

  def thumbor
    ThumborHandler.new(file_url)
  end

  class ThumborHandler

    def initialize(file_url)
      @file_url = file_url
    end

    def file_url(width: nil, height: nil)
      crypto = Thumbor::CryptoURL.new ENV.fetch('THUMBOR_SECURITY_KEY')
      path = crypto.generate(width: width, height: height, :image => CGI.escape(@file_url))
      ENV.fetch('THUMBOR_HOST').chomp('/') + path
    end

  end

end
