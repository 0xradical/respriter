class CourseReviewMailer < ApplicationMailer
  def build
    @course_review = params[:course_review]
    @user = @course_review.user_account
    @course = @course_review.course_name
    @provider = @course_review.provider
    @profile = @user.profile
    @name =
      (@profile&.username || @profile&.name&.upcase_first || '').split(/\b+/)
        .first
    @locale =
      (
        @user.tracking_data&.fetch('preferred_languages', %w[en]).map(
          &:to_sym
        ) &
          I18n.available_locales
      )
        .first

    subject =
      if @name
        choice = SecureRandom.random_number(3) + 1
        I18n.t(
          "emails.course_review.subjects.#{choice}",
          course: @course,
          name: @name,
          locale: @locale,
          provider: @provider.name
        )
      else
        I18n.t(
          'emails.course_review.subjects.1',
          course: @course, locale: @locale, provider: @provider.name
        )
      end

    if !@course_review.submitted?
      mail(
        {
          from: 'Classpert <contact@classpert.com>',
          to: (@name.present? ? "#{@name} <#{@user.email}>" : @user.email),
          subject: subject,
          reply_to: 'Classpert <contact@classpert.com>'
        }
      )
    end
  end
end
