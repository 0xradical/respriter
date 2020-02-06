module Napoleon
  class Resource
    attr_reader :payload, :provider

    def initialize(payload, provider = nil)
      @payload = payload
      @provider = provider
    end

    def to_course
      {
        id: payload['id'],
        dataset_sequence: dataset_sequence,
        name: payload['content']['course_name'],
        audio: payload['content']['audio'],
        slug: payload['content']['slug'],
        subtitles: payload['content']['subtitles'],
        price: payload['content']['price'],
        url: payload['content']['url'],
        pace: payload['content']['pace'],
        level: Array.wrap(payload['content']['level']),
        effort: payload['content']['effort'],
        free_content: payload['content']['free_content'],
        paid_content: payload['content']['paid_content'],
        description: payload['content']['description'],
        syllabus: payload['content']['syllabus'],
        certificate: payload['content']['certificate'],
        offered_by: payload['content']['offered_by'],
        instructors: payload['content']['instructors'],
        video: payload['content']['video'],
        category: payload['content']['category'],
        tags: payload['content']['tags'],
        published: payload['content']['published'],
        __source_schema__: payload,
        provider_id: provider_id
      }
    end

    def to_s
      payload.to_s
    end

    def version
      payload['content']['version']
    end

    def provider_id
      return payload['provider_id'] if payload['provider_id'].present?

      if provider
        provider.id
      else
        Provider.find_by(name: payload['content']['provider_name'])&.id
      end
    end

    def dataset_sequence
      payload['dataset_sequence']
    end
  end
end
