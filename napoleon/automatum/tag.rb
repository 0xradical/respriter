module Napoleon::Automatum
  class Tag < Base
    attr_reader :data

    def initialize(first_state, last_state, data)
      super first_state, last_state
      @data = data
    end

    def match(tokens, index)
      token = tokens[index]

      return [] if token.nil?
      return [] unless token.type == expected_type && ":#{token.value}".to_sym == data[:name]

      [ index + 1, 0 ]
    end

    def expected_type
      :Element
    end

    def inspect_detail
      data[:name]
    end

    def further_match
      "an opening \"#{data[:name].to_s.gsub(':', ' ').strip}\" tag"
    end
    alias :expecting :further_match

    def ==(other)
      super(other) && @data == other.data
    end
  end

  class CloseOpenTag < Tag
    def expected_type
      :ElementOpenClose
    end

    def further_match
      "a closing (\">\") for open tag #{data[:name].to_s.gsub(':', ' ').strip}"
    end
    alias :expecting :further_match
  end

  class CloseTag < Tag
    def expected_type
      :ElementClose
    end

    def further_match
      "a closing tag </#{data[:name].to_s.gsub(':', ' ').strip}>"
    end
    alias :expecting :further_match
  end
end
