module Napoleon
  class IntegrationResource < Resource
    BASE_62 = [*(0..9).map(&:to_s), *('a'..'z'), *('A'..'Z')].map(&:to_sym)

    attr_reader :id, :url, :data, :provider

    def initialize(id, url, provider, data)
      @id, @url, @provider, @data = id, url, provider, data
      super(to_payload, provider)
    end

    def to_payload
      payload = { 'content' => {} }

      payload['id'] = id
      payload['content']['version'] = data['version']
      payload['content']['course_name'] = data['course']['name']
      payload['content']['level'] = data['course']['level']
      payload['content']['description'] = data['course']['description']
      payload['content']['pace'] = data['course']['pace']
      payload['content']['audio'] = data['course']['audio']
      payload['content']['subtitles'] = data['course']['subtitles']
      payload['content']['video'] = data['course']['video']
      payload['content']['prices'] = data['course']['prices']
      payload['content']['url'] = url
      payload['content']['slug'] =
        data['course']['slug'] || slug(data['course']['name'], url)

      payload
    end

    def slug(course_name, course_url)
      [
        I18n.transliterate(course_name).downcase,
        digest(Zlib.crc32(course_url))
      ].join('-')
        .gsub(/[\s\_\-]+/, '-')
        .gsub(/[^0-9a-z\-]/i, '')
        .gsub(/(^\-)|(\-$)/, '')
    end

    def digest(n, carry = [])
      return carry.join if n == 0
      index = n % 62
      carry.unshift BASE_62[index]
      digest n / 62, carry
    end
  end
end
