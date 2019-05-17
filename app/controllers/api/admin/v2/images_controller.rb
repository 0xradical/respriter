module Api
  module Admin
    module V2
      class ImagesController < ActionController::API

        prepend_before_action :load_imageable, only: :create

        def new
          @image = Image.new
          render json: ImageSerializer.new(@image)
        end

        def edit
          @image = Image.find(params[:id])
          render json: ImageSerializer.new(@image)
        end

        def create
          @image = @imageable.attach_image!(image_params)
          render json: ImageSerializer.new(@image)
        end

        def update
          @image = Image.find(params[:id])
          @image.update(image_params)
          render json: ImageSerializer.new(@image)
        end

        def destroy
          @image = Image.find(params[:id])
          @image.destroy!
          render json: ImageSerializer.new(@image)
        end

        private

        def load_imageable
          params.keys.select { |k| k =~ /([a-z_]*)_id/ }.first
          @imageable = $1.camelcase.constantize.find(params["#{$1}_id"])
        end

        def image_params
          params.require(:image).permit(:file, :id, :caption, :pos)
        end

      end
    end
  end
end

