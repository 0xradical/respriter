module Developers
  class PreviewCourseProcessorJob < Que::Job
    class Error < StandardError; end

    self.priority = 100

    def run(id)
      preview_course = PreviewCourse.find(id)

      data       = preview_course.data || { 'course' => {} }
      course_url = data.dig('course', 'url')

      screenshooter = HTMLScreenshooter.new

      screenshooter.capture("https://classpert.com/udemy/courses/3d-printing-business-secrets-from-modeling-to-marketing-1gVriS", "png", { width: 1024, full_page: true }) do |file|
        preview_course.add_screenshot!(:desktop_course_page_screenshot, { file: file })
      end

      screenshooter.capture("https://classpert.com/udemy/courses/3d-printing-business-secrets-from-modeling-to-marketing-1gVriS", "png", { width: 800, full_page: true }) do |file|
        preview_course.add_screenshot!(:mobile_course_page_screenshot, { file: file })
      end

      data['course']['payload'] = {
        processed: true,
        screenshots: {
          desktop: preview_course.desktop_course_page_screenshot.file_url,
          mobile: preview_course.mobile_course_page_screenshot.file_url
        }
      }

      PreviewCourse.transaction do
        preview_course.update({
          status: 'succeeded',
          data: data
        })

        finish
      end
    rescue
      if error_count < 10
        raise PreviewCourseProcessorJob::Error
      else
        PreviewCourse.transaction do
          crawler_domain.update(status: 'failed')
          expire
        end
      end
    end
  end
end