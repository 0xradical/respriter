module Napoleon
  class IntegrationResource < Resource
    BASE_62 = [*(0..9).map(&:to_s), *('a'..'z'), *('A'..'Z')].map(&:to_sym)

    attr_reader :id, :data, :provider

    def initialize(id, provider, data)
      @id, @provider, @data = id, provider, (data || {})
      if @data['course_name'] && @data['url']
        @data['slug'] = slug(@data['course_name'], @data['url'])
      end
      super(to_payload, provider)
    end

    def to_payload
      { 'id' => id, 'content' => data }
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
