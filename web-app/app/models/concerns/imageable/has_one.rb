module Imageable
  module HasOne
    extend ActiveSupport::Concern

    included do
      @lazy_load_assoc = proc do |assoc_name|
        has_one assoc_name, as: :imageable, class_name: 'Image', dependent: :destroy
      end
    end

    def attach_image!(attributes)
      blob_params  = attributes.extract!(:file)
      send("create_#{(image_assoc_name || 'image')}", attributes).tap do |image|
        image.file = blob_params[:file]
      end.save!
      send(image_assoc_name)
    end

    def image_assoc_name
      self.class._assoc_name
    end

    class_methods do

      def initialize_imageable_module(assoc_name=:image)
        @assoc_name = assoc_name
        class_eval do

          define_method "#{assoc_name}_url" do |version = nil|
            send(assoc_name).try(:file_url, version)
          end

        end
        @lazy_load_assoc.call(assoc_name)
      end

      def _assoc_name
        @assoc_name
      end

    end
  end

end
