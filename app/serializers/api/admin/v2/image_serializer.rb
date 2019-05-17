module Api
  module Admin
    module V2
      class ImageSerializer < ResourceSerializer

        link :url do |object|
          api_admin_v2_image_url(object.id, host: host)
        end

        attributes :file_url, :caption, :pos

        attribute :thumbor, if: Proc.new { |object, params| params[:thumbor].present? if params } do
          width, height = params[:thumbor][:width], params[:thumbor][:height]
          { 
            size: "#{width}x#{height}", 
            url: object.thumbor.file_url(width: width, height: height) 
          }
        end

      end
    end
  end
end
