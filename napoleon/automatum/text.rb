module Napoleon::Automatum
  class Text < StringAutomatum
    def match(tokens, index)
      token = tokens[index]

      return [] if token.nil?
      return [] unless (token.type == :CDATA || token.type == :Text) && value_to_match(token.value) == content_to_match

      [ index + 1, 0 ]
    end

    def further_match
      "a Text or CDATA starting with \"#{content_to_match.truncate 60}\""
    end
    alias :expecting :further_match
  end
end
