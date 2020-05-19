module Napoleon::Automatum
  class StringAutomatum < Base
    attr_reader :content

    def initialize(first_state, last_state, content)
      super first_state, last_state
      @content = content
    end

    def match(tokens, index)
      token = tokens[index]

      return [] if token.nil?
      return [] unless token.type == expected_type && value_to_match(token.value) == content_to_match

      [ index + 1, 0 ]
    end

    def value_to_match(value)
      value.gsub(/\s+/, ' ').strip
    end

    def content_to_match
      @content_to_match ||= content.gsub(/\s+/, ' ').strip
    end

    def ==(other)
      super(other) && @content == other.content
    end

    alias :inspect_detail :content
    alias :expecting :further_match
  end
end
