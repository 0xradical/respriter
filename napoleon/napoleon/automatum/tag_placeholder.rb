module Napoleon::Automatum
  class TagPlaceholder < Base
    attr_reader :data

    def initialize(first_state, last_state, data)
      super first_state, last_state
      @data = data
    end

    def extract_data(context, tokens)
      context.next_context @data[:identifier], @data
    end

    def inspect_detail
      @data[:identifier].join('/').to_sym
    end

    def ==(other)
      super(other) && @data == other.data
    end

    def further_match
      'a Placeholder'
    end
  end

  class TagPlaceholderClose < TagPlaceholder
    def extract_data(context, tokens)
      format_capture(context) if data[:singleton] && !data[:single_content]
      context.parent
    end

    def further_match
      'a Placeholder'
    end

    protected
    def format_capture(context)
      data           = [ { children: [] } ]
      last_tag       = data[0]
      children_stack = [ last_tag[:children] ]

      context.value.each do |type, value|
        case type
        when :TagOpen
          tag = { type: :tag, name: value, children: [] }
          children_stack.last.push tag
          children_stack.push tag[:children]
          last_tag = tag
        when :Attribute
          last_tag[:attributes] ||= Hash.new
          last_tag[:attributes][value[0].to_sym] = value[1]
        when :TagOpenClose
          last_tag = nil
        when :TagClose
          children_stack.pop
        else
          params = { type: type.to_s.downcase.to_sym, value: value }
          children_stack.last.push params
        end
      end

      if data[0][:children].compact.blank?
        context.replace nil
        return
      end

      doc = Nokogiri::HTML::DocumentFragment.parse ''
      Nokogiri::HTML::Builder.with(doc) do |nested_doc|
        build_fragment nested_doc, data[0][:children]
      end
      context.replace doc.to_html
    end

    def build_fragment(doc, data)
      data.compact.each do |node|
        case node[:type]
        when :tag
          doc.public_send node[:name] do |nested_doc|
            build_fragment nested_doc, node[:children]
          end
        when :text
          doc.text node[:value]
        when :comment
          doc.comment node[:value]
        when :cdata
          doc.cdata node[:value]
        else
          raise 'Tem algo errado aqui'
        end
      end
    end
  end
end
