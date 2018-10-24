module Imageable
  module HasMany
    extend ActiveSupport::Concern

    included do
      has_many :images,   -> { order(pos: :asc)     }, as: :imageable, class_name: 'Image', dependent: :destroy
      scope :with_images, -> { includes(:images)    }
    end

    def main_image
      images.order(pos: :asc).first
    end

    def main_image_url(version=:lg)
      main_image.file_url(version)
      rescue
        "placeholders/" + [version, placeholder].compact.join('_')
    end

    def other_images
      images - [images.first]
    end

    def attach_image!(attributes)
      blob_params  = attributes.extract!(:file)
      images.create.tap do |image|
        image.file = blob_params[:file]
      end.save!
      images.last
    end

    def upload_exceeded?
      images.count >= _upload_limit
    end

    protected

    def _upload_limit
      self.class._upload_limit
    end

    module ClassMethods

      def upload_limit(limit=10)
        @upload_limit = limit
      end

      def _upload_limit
        @upload_limit || 4
      end

    end
  end
end

