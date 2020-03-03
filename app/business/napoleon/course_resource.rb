module Napoleon
  class CourseResource
    attr_reader :payload, :provider

    def initialize(payload, provider = nil)
      @payload  = payload
      @provider = provider
    end

    def to_course
      {
        id:                payload['resource_id'],
        global_sequence:   payload['id'],
        dataset_sequence:  dataset_sequence,
        schema_version:    version,
        last_execution_id: payload['last_execution_id'],
        resource_sequence: payload['sequence'],
        name:              payload['content']['course_name'],
        audio:             payload['content']['audio'],
        slug:              payload['content']['slug'],
        subtitles:         payload['content']['subtitles'],
        price:             payload['content']['price'],
        url:               payload['content']['url'],
        pace:              payload['content']['pace'],
        level:             Array.wrap(payload['content']['level']),
        effort:            payload['content']['effort'],
        free_content:      payload['content']['free_content'],
        paid_content:      payload['content']['paid_content'],
        description:       payload['content']['description'],
        syllabus:          payload['content']['syllabus'],
        certificate:       payload['content']['certificate'],
        offered_by:        payload['content']['offered_by'],
        instructors:       payload['content']['instructors'],
        video:             payload['content']['video'],
        category:          payload['content']['category'],
        tags:              payload['content']['tags'],
        published:         payload['content']['published'],
        __source_schema__: payload,
        provider_id:       provider_id

        # # Fields that are already handled
        # audio
        # certificate
        # course_name
        # description
        # effort
        # free_content
        # id
        # instructors
        # level
        # offered_by
        # pace
        # paid_content
        # published
        # subtitles
        # syllabus
        # url
        # video

        # # Fields that should be ignored from napoleon and handled by web-app
        # slug
        # reviewed

        # # Fields that must have being handled
        # provided_categories
        # provided_tags

        # # Fields that are not handled right now but should have
        # workload
        # language
        # duration

        # # Fields That should have being handled in another way
        # prices
        # rating
        # provider_id / provider_name
        # tags
        # category

        # # Fields that are ignored right now but that would be nice to be handled
        # status
        # stale
        # alternative_course_id
        # enrollments

        # # Ignored fields that maybe should continue to be like that
        # json_ld
        # extra
        # extra_content
      }
    end

    def to_s
      payload.to_s
    end

    def version
      payload['schema_version'] || payload['content']['version']
    end

    def provider_id
      if provider
        provider.id
      else
        payload.dig('content', 'provider_id') || Provider.find_by(name: payload.dig('content', 'name'))&.id
      end
    end

    def dataset_sequence
      payload['dataset_sequence']
    end
  end
end
