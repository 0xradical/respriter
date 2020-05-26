class VideosController < ApplicationController

  def show
    @course = Course.find(params[:id])
    render json: (@course.video.nil? ? {} : EmbeddedVideoParametizer.new(@course.video).parametize)
  end

end
