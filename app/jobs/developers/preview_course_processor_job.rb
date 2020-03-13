module Developers
  class PreviewCourseProcessorJob < BaseJob
    SERVICE_NAME = 'debug-tool-service'
    DEFAULT_VERSION = '1.0.0'

    def run(provider_crawler_id, preview_course_id, session_id = preview_course_id)
      job = Class.new(self.class).tap do |klass|
        klass.session_id = session_id
        klass.service_name = SERVICE_NAME
        klass.user_agent_token = ProviderCrawler.find_by(id: provider_crawler_id)&.user_agent_token
      end.new({})

      job.process(preview_course_id)
    end

    def process(id)
      error = nil

      log('Started debug tool processing')

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

      log('Fetching page')
      response = get_response(URI(preview_course.url))

      payload =
        if response.code != '200'
          raise "#120002: Course URL returned status code #{response.code}"
        else
          response.body
        end

      log('Parsing page')
      document = Nokogiri.HTML(payload)

      log('Looking for Classpert JSON')
      json = document.css('script[type="application/vnd.classpert+json"] text()').text.presence

      if json.nil?
        raise "#120003: Course page doesn't have a vnd.classpert+json JSON"
      end

      data =
        begin
          JSON.parse(json).merge('url': preview_course.url)
        rescue StandardError
          raise "#120004: Course page's vnd.classpert+json could not be parsed"
        end

      schema_version = data.delete('version') || DEFAULT_VERSION
      log("Using #{schema_version} schema version")

      resource =
      ::Napoleon::IntegrationResource.new(
        preview_course.id,
        preview_course.provider,
        data
      )

      log('Validating JSON')
      validator =
        Integration::Napoleon::SchemaValidator.new('course', schema_version)

      _, validation_errors = validator.validate(resource.data)

      if validation_errors.size > 0
        validation_errors.each do |validation_error|
          log("Validation error: #{validation_error.message}", :error)
        end

        raise "#120005: Course page's vnd.classpert+json is not valid"
      else
        log('Successfully validated JSON')
      end

      log('Generating resource based on JSON')
      begin
        PreviewCourse.upsert(
          resource.to_course.merge(expired_at: 20.minutes.from_now)
        )

        preview_course.reload
      rescue StandardError
        raise '#120006: Debug structure could not be generated'
      end

      screenshooter = HTMLScreenshooter.new

      begin
        log("Capturing screenshot of preview page's desktop version")
        screenshooter.capture(
          preview_url,
          'png',
          { width: 1_024, full_page: true, force: true }
        ) { |file| preview_course.add_screenshot!(:desktop, file) }

        log("Capturing screenshot of preview page's mobile version")
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

        log('Successfully finished debug tool processing')
      end
    rescue => e
      error = e
    ensure
      if error
        log(error.message, :error)

        if preview_course
          PreviewCourse.transaction do
            preview_course.update({ status: 'failed' })
            expire
          end
        else
          expire
        end
      end
    end
  end
end
