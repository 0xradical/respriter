module Developers
  class PreviewCourseProcessorJob < Que::Job
    class Error < StandardError; end

    self.priority = 100

    def run(id)
      preview_course = PreviewCourse.find(id)
      preview_uri    = URI.join(ENV['CLASSPERT_URL'], "/developers/preview_courses/", preview_course.id)
      provider       = preview_course.provider
      data           = preview_course.data || { 'course' => {} }
      course_url     = data.dig('course', 'url')
      payload        = Net::HTTP.get(URI(course_url))
      document       = Nokogiri::HTML(payload)
      course_data    = JSON.parse(document.css('script[type="application/vnd.classpert+json"] text()').text)
      resource       = ::Napoleon::Resource.from_integration(provider, course_data, course_url)
      course_json    = nil
      screenshooter  = HTMLScreenshooter.new

      Course.transaction do
        course_json = Course.upsert(resource.to_course).as_indexed_json
        course_json[:id] = preview_course.id
        course_json[:gateway_path] = course_url
        raise ActiveRecord::Rollback
      end

      data['course']['payload'] = course_json

      preview_course.update(data: data)

      desktop_screenshot = screenshooter.capture(preview_uri, "png", { width: 1024, full_page: true }) do |file|
        preview_course.add_screenshot!(:desktop, file)
      end

      mobile_screenshot = screenshooter.capture(preview_uri, "png", { width: 800, full_page: true }) do |file|
        preview_course.add_screenshot!(:mobile, file)
      end

      data['course']['screenshots'] = {
        desktop: desktop_screenshot.file_url,
        mobile: mobile_screenshot.file_url
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