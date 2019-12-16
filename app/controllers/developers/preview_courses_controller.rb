module Developers
  class PreviewCoursesController < ApplicationController
    def show
      @preview_course = PreviewCourse.find(params[:id])
    end
  end
end