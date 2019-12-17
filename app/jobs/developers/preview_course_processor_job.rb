module Developers
  class PreviewCourseProcessorJob < Que::Job
    class Error < StandardError; end

    self.priority = 100

    def run(id)
      error          = nil

      preview_course = on_error("Preview not found") { PreviewCourse.find(id) }
      classpert_uri  = on_nil("Classpert URI not set") { ENV['CLASSPERT_URL'] }

      preview_uri    = URI.join(classpert_uri, "/developers/preview_courses/", preview_course.id)
      provider       = on_nil("Preview's provider is null") { preview_course.provider }

      data           = preview_course.data || { 'course' => {} }
      course_url     = on_nil("Course URL is null") { data.dig('course', 'url') }

      response       = Net::HTTP.get_response(URI(course_url))
      payload        = if response.code != "200"
        raise "Course URL returned status code #{response.code}"
      else
        response.body
      end

      document       = Nokogiri::HTML(payload)

      course_struct  = on_nil("Course JSON not present on URL's page") do
        document.css('script[type="application/vnd.classpert+json"] text()').text.presence
      end

      course_data    = on_error("Could not parse Course JSON") do
        JSON.parse(course_struct)
      end

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
    rescue => e
      error = e.message
    ensure
      if error
        PreviewCourse.transaction do
          preview_course.update({
            status: 'failed',
            data: {
              error: error
            }
          })
          expire
        end
      end
    end

    def on_error(message)
      begin
        yield
      rescue
        raise message
      end
    end

    def on_nil(message)
      value = yield

      if value
        value
      else
        raise message
      end
    end
  end
end