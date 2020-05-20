class CourseReviewsController < ApplicationController
  def show
    @course_review = CourseReview.find(params[:id])
    @rating = rating || @course_review.rating
  end

  def update
    @course_review = CourseReview.find(params[:id])
    @rating = Integer(course_review_params['rating']) rescue (rating || @course_review.rating)

    ActiveRecord::Base.transaction do
      if @course_review.update!(course_review_params)
        @course_review.update(state: CourseReview::SUBMITTED)
      end
    end

    @course_review.reload

    render :show
  end

  protected

  def course_review_params
    params.require(:course_review).permit(:completed, :feedback, :rating)
  end

  def rating
    Integer(params.require(:rating)) rescue nil
  end
end