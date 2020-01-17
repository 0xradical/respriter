require 'syslogger'

module Developers
  class PreviewCourseProcessorJob < Que::Job
    SERVICE_NAME = 'debug-tool-service'
    DEFAULT_VERSION = '0.0.1'

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

      preview_course = PreviewCourse.find_by(id: id)
      if preview_course.nil?
        raise '#120000: Debug structure not found on database'
      end

      classpert_uri = ENV['CLASSPERT_URL']
      raise '#120001: Classpert URI not set' if classpert_uri.nil?

      preview_url =
        URI.join(
          classpert_uri,
          '/developers/preview_courses/',
          preview_course.id
        )

      log(id, 'Fetching page')
      response = Net::HTTP.get_response(URI(preview_course.url))

      payload =
        if response.code != '200'
          raise "#120002: Course URL returned status code #{response.code}"
        else
          response.body
        end

      log(id, 'Parsing page')
      document = Nokogiri.HTML(payload)

      log(id, 'Looking for JSON+LD')
      json =
        document.css('script[type="application/vnd.classpert+json"] text()')
          .text
          .presence

      if json.nil?
        raise "#120003: Course page doesn't have a vnd.classpert+json structure"
      end

      data =
        begin
          JSON.parse(json).merge('url': preview_course.url)
        rescue StandardError
          raise "#120004: Course page's vnd.classpert+json structure is malformed"
        end

      schema_version = data.delete('version') || DEFAULT_VERSION
      log(id, "Using #{schema_version} schema version")

      log(id, 'Validating JSON')
      validator =
        Integration::Napoleon::SchemaValidator.new('course', schema_version)

      data, validation_errors = validator.validate(data)

      if validation_errors.size > 0
        validation_errors.each do |validation_error|
          log(id, "Validation error: #{validation_error.message}", :error)
        end

        raise "#120005: Course page's vnd.classpert+json is not valid"
      else
        log(id, 'Successfully validated JSON')
      end

      log(id, 'Generating resource based on JSON')
      begin
        resource =
          ::Napoleon::IntegrationResource.new(
            preview_course.id,
            preview_course.provider,
            data
          )

        PreviewCourse.upsert(
          resource.to_course.merge(expired_at: 20.minutes.from_now)
        )

        preview_course.reload
      rescue StandardError
        raise '#120006: Debug structure could not be generated'
      end

      screenshooter = HTMLScreenshooter.new

      begin
        log(id, "Capturing screenshot of preview page's desktop version")
        screenshooter.capture(
          preview_url,
          'png',
          { width: 1_024, full_page: true, force: true }
        ) { |file| preview_course.add_screenshot!(:desktop, file) }

        log(id, "Capturing screenshot of preview page's mobile version")
        screenshooter.capture(
          preview_url,
          'png',
          { width: 800, full_page: true, force: true }
        ) { |file| preview_course.add_screenshot!(:mobile, file) }
      rescue StandardError
        raise '#120007: Debug screenshotting failed'
      end

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
        if preview_course
          PreviewCourse.transaction do
            preview_course.update({ status: 'failed' })
            expire
          end
        else
          expire
        end

        log(id, error.message, :error)
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

    def log(ctx_id, message, level = :info)
      self.logger.public_send(
        level,
        {
          id: SecureRandom.uuid,
          ps: { id: ctx_id, name: SERVICE_NAME },
          payload: message
        }.to_json
      )
    end
  end
end
