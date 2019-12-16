module Napoleon
  class Resource
    BASE_62 = [*(0..9).map(&:to_s), *('a'..'z'), *('A'..'Z')].map(&:to_sym)

    attr_reader :payload, :provider

    def initialize(payload, provider = nil)
      @payload  = payload
      @provider = provider
    end

    def to_course
      {
        id:                payload['id'],
        audio:             payload['content']['audio'],
        category:          payload['content']['category'],
        certificate:       payload['content']['certificate'],
        dataset_sequence:  payload['dataset_sequence'],
        description:       payload['content']['description'],
        effort:            payload['content']['effort'],
        free_content:      payload['content']['free_content'],
        instructors:       payload['content']['instructors'],
        level:             Array.wrap(payload['content']['level']),
        name:              payload['content']['course_name'],
        offered_by:        payload['content']['offered_by'],
        pace:              payload['content']['pace'],
        paid_content:      payload['content']['paid_content'],
        price:             payload['content']['price'],
        published:         payload['content']['published'],
        slug:              payload['content']['slug'],
        subtitles:         payload['content']['subtitles'],
        syllabus:          payload['content']['syllabus'],
        tags:              payload['content']['tags'],
        url:               payload['content']['url'],
        video:             payload['content']['video'],
        __source_schema__: payload,
        provider_id:       provider_id
      }
    end

    def to_s
      payload.to_s
    end

    def version
      payload['content']['version']
    end

    def provider_id
      return payload[:provider_id] if payload[:provider_id].present?

      if provider
        provider.id
      else
        Provider.find_by(name: payload['content']['provider_name'])&.id
      end
    end

    def dataset_sequence
      payload['dataset_sequence']
    end

    def self.slug(course_name, course_url)
      [
        I18n.transliterate(course_name).downcase,
        digest(Zlib.crc32(course_url))
      ].join('-').gsub(/[\s\_\-]+/, '-').gsub(/[^0-9a-z\-]/i, '').gsub(/(^\-)|(\-$)/, '')
    end

    def self.from_integration(provider, json, url)
      payload = {'content' => {}}

      payload['content']['version']     = json['version']
      payload['content']['course_name'] = json['course']['name']
      payload['content']['level']       = json['course']['level']
      payload['content']['description'] = json['course']['description']
      payload['content']['pace']        = json['course']['pace']
      payload['content']['audio']       = json['course']['audio']
      payload['content']['subtitles']   = json['course']['subtitles']
      payload['content']['video']       = json['course']['video']
      payload['content']['prices']      = json['course']['prices']
      payload['content']['url']         = url
      payload['content']['slug']        = json['course']['slug'] || slug(json['course']['name'], url)

      self.new(payload, provider)
    end

    def self.digest(n, carry = [])
      return carry.join if n == 0
      index = n%62
      carry.unshift BASE_62[index]
      digest n/62, carry
    end
  end
end
