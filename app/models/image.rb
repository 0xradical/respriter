class Image < ApplicationRecord

  belongs_to :imageable, polymorphic: true
  mount_uploader :file, ImageUploader

  def thumbor
    ThumborHandler.new file_url
  end

  class ThumborHandler

    def initialize(file_url)
      if Rails.env.production?
        @file_url = file_url
      else
        public_host     = ENV.fetch 'AWS_S3_ASSET_HOST'
        dockerized_host = ENV.values_at('AWS_S3_ENDPOINT', 'AWS_S3_BUCKET_NAME').join '/'
        @file_url = file_url.gsub public_host, dockerized_host
      end
    end

    # width:   <int>                                                            # width for the thumbnail
    # height:  <int>                                                            # height for the thumbnail
    # crop:    [<int>, <int>, <int>, <int>]                                     # Coordinates for cropping (left, top, right and bottom)
    # flip:    <bool>                                                           # flip horizontally
    # flop:    <bool>                                                           # flip vertically
    # halign:  :left | :center | :right                                         # horizontal alignment
    # valign:  :top  | :middle | :bottom                                        # vertical alignment
    # filters: ['blur(20)', 'watermark(http://my.site.com/img.png,-10,-10,50)'] # array of filters and their arguments
    # meta:    <bool>                                                           # return only meta-data on the operations it would otherwise perform
    def file_url(**options)
      crypto = Thumbor::CryptoURL.new ENV.fetch('THUMBOR_SECURITY_KEY')
      path = crypto.generate options.merge(image: CGI.escape(@file_url))
      ENV.fetch('THUMBOR_HOST').chomp('/') + path
    end

  end

end
