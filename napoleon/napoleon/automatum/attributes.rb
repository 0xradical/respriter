module Napoleon::Automatum
  class Attributes < Base
    attr_reader :required_attributes, :optional_attributes, :extra_attributes

    def initialize(first_state, last_state, attributes)
      super first_state, last_state
      prepare attributes
    end

    def match(tokens, index)
      required_attributes_count = @required_attributes.size
      while tokens[index] && tokens[index].type == :AttributeName
        attribute_name = tokens[index].value.to_sym
        index += 2

        if @required_attributes.has_key?(attribute_name)
          required_attributes_count -= 1
          next
        end

        next if @optional_attributes.has_key?(attribute_name)

        return [] if @extra_attributes.nil?
      end

      required_attributes_count == 0 ? [ index, 0 ] : []
    end

    def extract_data(context, tokens)
      extra_attrs = Hash.new

      tokens.each_slice(2) do |name_token, value_token|
        name, value = value_token.value
        kind, identifiers = @required_attributes[name.to_sym] || @optional_attributes[name.to_sym]

        if kind == :placeholder
          attr_context = context.next_context identifiers, single_content: true
          attr_context.set value
          next
        end

        if @extra_attributes.present? && @extra_attributes != :'~'
          extra_attrs[name.to_sym] = value
        end
      end

      if extra_attrs.present?
        extra_context = context.next_context [@extra_attributes], single_content: true
        extra_context.set extra_attrs
      end

      context
    end

    def further_match
      "at least those attributes: #{ @required_attributes.keys.join ', ' }"
    end
    alias :expecting :further_match

    def ==(other)
      super(other) &&
      @required_attributes == other.required_attributes &&
      @optional_attributes == other.optional_attributes &&
      @extra_attributes    == other.extra_attributes
    end

    protected
    def prepare(attributes)
      @required_attributes = Hash.new
      @optional_attributes = Hash.new
      @extra_attributes    = nil

      attributes.each do |type, attribute|
        case type
        when :attribute
          name, value = attribute_key_and_value attribute
          if attribute[:optional]
            @optional_attributes[name.to_sym] = value
          else
            @required_attributes[name.to_sym] = value
          end
        when :attributes_placeholder
          @extra_attributes = attribute.first.to_sym
        end
      end
    end

    def attribute_key_and_value(attribute)
      [
        [ attribute[:namespace], attribute[:name] ].compact.join(':'),
        attribute[:value]
      ]
    end
  end
end
