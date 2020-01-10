module Developers
  class PreviewCoursesController < ApplicationController
    def show
      @preview_course = PreviewCourse.find(params[:id])

      if Time.now > @preview_course.expired_at
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end
