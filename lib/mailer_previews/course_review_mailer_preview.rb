class CourseReviewMailerPreview < ActionMailer::Preview
  def build
    user_account = UserAccount.find(351)
    course_review = user_account.course_reviews.first

    CourseReviewMailer.with(course_review: course_review).build
  end
end