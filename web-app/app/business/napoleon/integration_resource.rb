module Napoleon
  class IntegrationResource < CourseResource
    BASE_62 = [*(0..9).map(&:to_s), *('a'..'z'), *('A'..'Z')].map(&:to_sym)

    attr_reader :id, :data, :provider

    def initialize(id, provider, data)
      @id, @provider, @data = id, provider, (data || {})
      @data['slug'] =
        slug(@data['slug'].presence || @data['course_name'].presence)
      @data['id'] = @data['id']&.strip
      @data['course_name'] = @data['course_name']&.strip
      @data['description'] = @data['description']&.strip
      super(to_payload, provider)
    end

    def to_payload
      { 'resource_id' => id, 'content' => data }
    end

    def slug(source)
      if source
        [
          I18n.transliterate(source).downcase,
          digest(Zlib.crc32("#{@provider.id}-#{@id}"))
        ].join('-')
          .gsub(/[\s\_\-]+/, '-')
          .gsub(/[^0-9a-z\-]/i, '')
          .gsub(/(^\-)|(\-$)/, '')
          .gsub(/[\s\_\-]+/, '-')
      else
        nil
      end
    end

    def digest(n, carry = [])
      return carry.join if n == 0
      index = n % 62
      carry.unshift BASE_62[index]
      digest n / 62, carry
    end
  end
end
