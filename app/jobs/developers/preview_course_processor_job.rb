require 'syslogger'

module Developers
  class PreviewCourseProcessorJob < Que::Job
    SERVICE_NAME = 'debug-tool-service'

    class Error < StandardError; end

    self.priority = 100

    attr_reader :logger

    def initialize(*)
      super

      @logger = SysLogger.new
    end

    def run(id)
      error = nil

      log(id, 'Started debug tool processing')

      preview_course = on_error('Preview not found') { PreviewCourse.find(id) }
      classpert_uri = on_nil('Classpert URI not set') { ENV['CLASSPERT_URL'] }

      preview_url =
        URI.join(
          classpert_uri,
          '/developers/preview_courses/',
          preview_course.id
        )

      response = Net::HTTP.get_response(URI(preview_course.url))

      payload =
        if response.code != '200'
          raise "Course URL returned status code #{response.code}"
        else
          response.body
        end

      document = Nokogiri.HTML(payload)

      json =
        on_nil("Course JSON not present on URL's page") do
          document.css('script[type="application/vnd.classpert+json"] text()')
            .text
            .presence
        end

      data = on_error('Could not parse Course JSON') { JSON.parse(json) }

      resource =
        ::Napoleon::IntegrationResource.new(
          preview_course.id,
          preview_course.url,
          preview_course.provider,
          data
        )

      PreviewCourse.upsert(resource.to_course)

      preview_course.reload

      screenshooter = HTMLScreenshooter.new

      screenshooter.capture(
        preview_url,
        'png',
        { width: 1_024, full_page: true, force: true }
      ) { |file| preview_course.add_screenshot!(:desktop, file) }

      screenshooter.capture(
        preview_url,
        'png',
        { width: 800, full_page: true, force: true }
      ) { |file| preview_course.add_screenshot!(:mobile, file) }

      PreviewCourse.transaction do
        preview_course.update(
          {
            status: 'succeeded',
            __indexed_json__: preview_course.as_indexed_json
          }
        )

        finish

        log(id, 'Successfully finished debug tool processing')
      end
    rescue => e
      error = e.message
    ensure
      if error
        PreviewCourse.transaction do
          preview_course.update({ status: 'failed' })
          expire
        end

        log(id, "Finished debug tool processing with error: #{error}")
      end
    end

    def on_error(message)
      yield
    rescue StandardError
      raise message
    end

    def on_nil(message)
      value = yield

      if value
        value
      else
        raise message
      end
    end

    def log(ctx_id, message)
      self.logger.info(
        {
          id: SecureRandom.uuid,
          ps: { id: ctx_id, name: SERVICE_NAME },
          payload: message
        }.to_json
      )
    end
  end
end
