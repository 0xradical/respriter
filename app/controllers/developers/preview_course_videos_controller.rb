module Developers
  class PreviewCourseVideosController < ApplicationController
    def show
      @preview_course = PreviewCourse.find(params[:id])

      render json: (@preview_course.video.nil? ? {} : EmbeddedVideoParametizer.new(@preview_course.video).parametize)
    end
  end
end