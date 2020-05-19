module Napoleon::Automatum
  class PlaceholderCapture < Base
    def extract_data(context, tokens)
      content = tokens.map(&:value).join.gsub /\s+/, ' '

      if context.try(:single_content)
        context.set content
      else
        context.set [ expected_type, content ]
      end

      context
    end

    def match(tokens, index)
      token = tokens[index]

      return [] if token.nil? || token.type != expected_type

      [ index + 1, 0 ]
    end

    alias :expecting :further_match
  end

  class TextCapture < PlaceholderCapture
    def further_match
      'a Text to be captured'
    end

    def expected_type
      :Text
    end
  end

  class CommentCapture < PlaceholderCapture
    def further_match
      'a Comment to be captured'
    end

    def expected_type
      :Comment
    end
  end

  class DTDCapture < PlaceholderCapture
    def further_match
      'a DTD to be captured'
    end

    def expected_type
      :DTD
    end
  end

  class CDATACapture < PlaceholderCapture
    def further_match
      'a CDATA to be captured'
    end

    def expected_type
      :CDATA
    end
  end

  class DoctypeCapture < PlaceholderCapture
    def expected_type
      :Doctype
    end
  end

  class TagCapture < Base
    attr_reader :tag_names

    def initialize(first_state, last_state, tag_names)
      super first_state, last_state
      @tag_names = tag_names
    end

    def match(tokens, index)
      token = tokens[index]

      return [] if token.nil?
      return [] unless token.type == :Element && ( @tag_names.include?(nil) || @tag_names.include?(token.value.to_sym) )
      index += 1

      index += 2 while tokens[index].type == :AttributeName

      return [] unless tokens[index].type == :ElementOpenClose

      [ index + 1, 1 ]
    end

    def ==(other)
      super(other) && @tag_names == other.tag_names
    end

    def extract_data(context, tokens)
      context.set [:TagOpen, tokens[0].value]
      tokens.shift

      while tokens[0].type == :AttributeName
        context.set [:Attribute, tokens[1].value]
        tokens.shift 2
      end

      context.set [:TagOpenClose]
      context
    end

    def further_match
      'a Tag to be captured'
    end
    alias :expecting :further_match
  end

  class CloseTagCapture < Base
    def match(tokens, index)
      token = tokens[index]

      return [] if token.nil? || token.type != :ElementClose

      [ index + 1, -1 ]
    end

    def extract_data(context, tokens)
      context.set [:TagClose]
      context
    end

    def further_match
      'a Tag to be captured'
    end
    alias :expecting :further_match
  end
end
