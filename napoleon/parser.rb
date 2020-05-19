module Napoleon
  class Parser
    def initialize(source_code)
      @source_code = source_code
    end

    def parse
      parse!
    rescue ParserError
      nil
    end

    def parse!
      @nodes   = []
      @scanner = StringScanner.new @source_code

      parse_root_nodes
      @nodes
    rescue ParserError => error
      error.position    = @scanner.pos
      error.source_code = @source_code
      raise error
    end

    protected
    def parse_root_nodes
      until @scanner.eos?
        node = parse_node
        @nodes << node
      end
    end

    def parse_node(parent_tag = nil)
      parse_processing_instruction      ||
      parse_doctype                     ||
      parse_cdata                       ||
      parse_comment                     ||
      parse_tag(parent_tag)             ||
      parse_tag_placeholder(parent_tag) ||
      parse_text(parent_tag)            ||
      raise(ParserError, "Expected a node, but couldn't get one")
    end

    def parse_children(current_tag)
      unless current_tag[:singleton]
        current_tag[:children] = []
        loop do
          child_or_close = parse_child(current_tag)
          break if child_or_close == :close_tag

          current_tag[:children] << child_or_close
        end
      end
    end

    def parse_child(parent_tag)
      parse_close_tag(parent_tag) || parse_node(parent_tag)
    end

    # TODO: Handle optional XML Processing Instruction
    def parse_processing_instruction
      return false unless @scanner.scan(/\<\?xml ([^\?]|\?[^\>])+\?\>/)
      [ :processing_instruction, @scanner.matched[6..-2].strip ]
    end

    # TODO: Handle optional DOCTYPE
    def parse_doctype
      return false unless @scanner.scan(/\<\!DOCTYPE[^\>]*\>/i)
      [ :doctype, @scanner.matched[9..-2].strip ]
    end

    # TODO: Handle optional CDATA
    def parse_cdata
      return false unless @scanner.scan(/\<\!\[CDATA\[(([^\]])|(\][^\]])|(\]\][^\>]))*\]\]\>/i)
      [ :cdata, @scanner.matched[9..-4] ]
    end

    # TODO: Handle optional COMMENT
    def parse_comment
      return false unless @scanner.scan(/\<\!\-\-(([^\-])|(\-[^\-])|(\-\-[^\>]))*\-\-\>/)
      [ :comment, @scanner.matched[4..-4] ]
    end

    NAME_IDENTIFIER = /((?<namespace>[\w\-]+)\:)?(?<name>[\w\-]+)/
    TAG_FLAGS       = /((?<flag>[\?\*\+]))/
    OPEN_TAG_REGEXP = /\<\s*#{TAG_FLAGS}?#{NAME_IDENTIFIER}/
    def parse_tag(parent_tag)
      return false if parent_tag && parent_tag[:text_mode] == :raw

      previous_position = @scanner.pos
      return false unless @scanner.scan(/#{OPEN_TAG_REGEXP}(?=[^\w\-])/)

      match = @scanner.matched.match OPEN_TAG_REGEXP
      tag = build_tag parent_tag, match[:namespace], match[:name], match[:flag]

      if tag[:flag] == :zero_or_more || tag[:flag] == :one_or_more
        raise(ParserError, 'Tags with iterators must have its iterator named') unless parse_tag_iterator(tag)
      end

      parse_attributes tag

      parse_children tag

      [ :tag, tag ]
    end

    PLACEHOLDER_KEY        = /[\w\-]+/
    PLACEHOLDER_NESTED_KEY = /(\[\s*#{PLACEHOLDER_KEY}\s*\])/
    PLACEHOLDER_FULL_KEY   = /#{PLACEHOLDER_KEY}(#{PLACEHOLDER_NESTED_KEY}*)/
    ARRAY_ITERATOR_REGEXP  = /\s*\(\s*(?<iterator>#{PLACEHOLDER_FULL_KEY})\s*\)/
    def parse_tag_iterator(current_tag)
      return false unless @scanner.scan(ARRAY_ITERATOR_REGEXP)
      match = @scanner.matched.match ARRAY_ITERATOR_REGEXP
      current_tag[:iterator] = parse_placeholder_identifier match[:iterator]
    end

    def parse_attributes(current_tag)
      loop do
        attr_or_close = parse_attribute_or_close(current_tag)
        break if attr_or_close == :close_tag

        current_tag[:attributes] << attr_or_close
      end
    end

    PLACEHOLDER_IDENTIFIER = /(?<placeholder>((#{PLACEHOLDER_FULL_KEY})|(\~)))/
    CLOSE_TAG_REGEXP       = /\<\/((#{NAME_IDENTIFIER})|(\@#{PLACEHOLDER_IDENTIFIER}))\>/
    def parse_close_tag(parent_tag)
      return false unless @scanner.scan(CLOSE_TAG_REGEXP)

      match = @scanner.matched.match CLOSE_TAG_REGEXP

      raise(ParserError, "Closing Tag mismatch") unless match[:placeholder].present? == parent_tag[:placeholder]

      if match[:placeholder].present?
        identifier = parse_placeholder_identifier match[:placeholder]
        raise(ParserError, 'Closing Placeholder Tag does not match') if identifier != parent_tag[:identifier]
      else
        namespace = match[:namespace].try :to_sym
        name      = match[:name].to_sym

        raise(ParserError, 'Closing Tag does not match') if parent_tag[:name] != name || parent_tag[:namespace] != namespace
      end

      :close_tag
    end

    def parse_attribute_or_close(current_tag)
      parse_close_opening_tag(current_tag) ||
      parse_attributes_placeholder ||
      parse_attribute ||
      raise(ParserError, "Expected an Attribute or Tag Closing, but couldn't get any of those'")
    end

    TEXT_FLAG_REGEXP = /(?<text_flag>[\#\&\!])/
    def parse_close_opening_tag(current_tag)
      return false unless @scanner.scan(/\s*#{TEXT_FLAG_REGEXP}?\s*\/?\>/)

      current_tag[:singleton] = !!@scanner.matched.match(/\//)

      flag = @scanner.matched.match(/\s*#{TEXT_FLAG_REGEXP}?\s*/)[:text_flag]
      current_tag[:text_mode] = parse_text_flag(flag) || current_tag[:text_mode]

      :close_tag
    end

    OPTIONAL_FLAG         = /(?<optional>[\?])/
    ATTRIBUTE_NAME_REGEXP = /\s*#{OPTIONAL_FLAG}?#{NAME_IDENTIFIER}/
    def parse_attribute
      return false unless @scanner.scan(/#{ATTRIBUTE_NAME_REGEXP}(?=((\s*[\@\=\/\>])|(\s+[\w\-])))/)

      match = @scanner.matched.match ATTRIBUTE_NAME_REGEXP
      attribute = {
        name:       match[:name],
        namespace:  match[:namespace],
        optional:   ( match[:optional] == '?' )
      }

      if @scanner.scan(/\s*\=\s*/)
        attribute[:value] = parse_double_quoted_string || parse_single_quoted_string or raise(ParserError, "Couldn't get attribute value for #{attribute[:name]}")
      else
        if @scanner.scan(/\s*\@\s*/)
          attribute[:value] = parse_attribute_with_placeholder or raise(ParserError, "Couldn't get attribute placeholder for #{attribute[:name]}")
        else
          attribute[:value] = [ :string, attribute[:name].dup ]
        end
      end

      [ :attribute, attribute ]
    end

    ATTRIBUTE_WITH_PLACEHOLDER_REGEXP = PLACEHOLDER_IDENTIFIER
    def parse_attribute_with_placeholder
      return false unless @scanner.scan(/#{ATTRIBUTE_WITH_PLACEHOLDER_REGEXP}(?=[\s\/\>])/)
      identifier = @scanner.matched.match(ATTRIBUTE_WITH_PLACEHOLDER_REGEXP)[:placeholder]
      [ :placeholder, parse_placeholder_identifier(identifier) ]
    end

    DOUBLE_QUOTED_STRING_REGEXP = /\"([^\\\"]|(\\.))*\"/
    def parse_double_quoted_string
      return false unless @scanner.scan(DOUBLE_QUOTED_STRING_REGEXP)
      [ :string, @scanner.matched[1..-2].gsub(/\\\"/, '"') ]
    end

    SINGLE_QUOTED_STRING_REGEXP = /\'([^\\\']|(\\.))*\'/
    def parse_single_quoted_string
      return false unless @scanner.scan(SINGLE_QUOTED_STRING_REGEXP)
      [ :string, @scanner.matched[1..-2].gsub(/\\\'/, "'") ]
    end

    ATTRIBUTES_PLACEHOLDER_REGEXP = /\s*\.#{PLACEHOLDER_IDENTIFIER}/
    def parse_attributes_placeholder
      return false unless @scanner.scan(/#{ATTRIBUTES_PLACEHOLDER_REGEXP}(?=[\s\/\>])/)
      identifier = @scanner.matched.match(ATTRIBUTES_PLACEHOLDER_REGEXP)[:placeholder]
      [ :attributes_placeholder, parse_placeholder_identifier(identifier) ]
    end

    STORE_TAG              = /tag(\(([\w\-]+(\:[\w\-]+)?)\))?/
    STORE_ELEMET           = /(text)|(comment)|(dtd)|(cdata)|(doctype)|(#{STORE_TAG})|(node)/
    STORE_LIST             = /\s+(?<store>(#{STORE_ELEMET})(\s+(#{STORE_ELEMET})\s*)*)/
    TAG_PLACEHOLDER_REGEXP = /\<\s*#{TAG_FLAGS}?\@#{PLACEHOLDER_IDENTIFIER}#{STORE_LIST}?\s*(?<singleton>\/)?\>/
    def parse_tag_placeholder(parent_tag)
      return false unless @scanner.scan(TAG_PLACEHOLDER_REGEXP)

      match = @scanner.matched.match(TAG_PLACEHOLDER_REGEXP)

      flag       = parse_flag match[:flag]
      identifier = parse_placeholder_identifier match[:placeholder]
      singleton  = !!match[:singleton]

      tag_placeholder = { flag: flag, placeholder: true, identifier: identifier, singleton: singleton, parent: parent_tag }

      if singleton
        if flag == :zero_or_more || flag == :one_or_more
          raise(ParserError, "Singleton Tag like #{tag_placeholder[:identifier]} could not have iterator flags")
        end

        store = if match[:store].present?
          store_strs = match[:store].strip.split /\s+/

          if store_strs.include? 'node'
            # TODO: adds dtd again
            store_strs = (store_strs - ['node'] + ['text', 'comment', 'cdata', 'doctype', 'tag']).uniq
          end

          grouped_strs = store_strs.group_by{ |str| str.match(/^tag/) ? :tag : :other }
          other = grouped_strs[:other] || []
          if grouped_strs[:tag]
            other.map(&:to_sym) + [ grouped_strs[:tag].map{ |t| t.match(STORE_TAG)[2].try :to_sym } ]
          else
            other.map(&:to_sym)
          end
        else
          [ :text ]
        end

        return [ :tag_placeholder, tag_placeholder.merge(store: store) ]
      end

      # raise(ParserError, "Open-Close Placeholder like #{tag_placeholder[:identifier]} Tags must be flagged as ?, *, or +")  if flag == :required
      raise(ParserError, "Open-Close Placeholder like #{tag_placeholder[:identifier]} Tags could not choose what to store") if match[:store].present?

      tag_placeholder[:text_mode] = extract_text_mode parent_tag
      parse_children tag_placeholder

      return [ :tag_placeholder, tag_placeholder ]
    end

    # TODO: Handle optional Text
    TEXT_REGEXP = /((\\\<)|([^\<]))+/
    def parse_text(parent_tag)
      text_mode = extract_text_mode parent_tag
      if text_mode == :raw
        full_name  = tag_full_name parent_tag
        close_size = full_name.size + 3
        content   = @scanner.scan_until(Regexp.new "</#{full_name}>")
        @scanner.pos -= close_size
        return build_text content[0..-(close_size+1)]
      end

      text = @scanner.scan TEXT_REGEXP
      return false unless text

      text.gsub!(/\s+/, ' ') if text_mode == :compact

      build_text text.gsub('\<', '<')
    end

    def build_text(content)
      [ :text, content ]
    end

    def parse_flag(flag)
      case flag
      when '?'
        :optional
      when '*'
        :zero_or_more
      when '+'
        :one_or_more
      else
        :required
      end
    end

    def parse_text_flag(flag)
      case flag
      when '#'
        :compact
      when '&'
        :preserve
      when '!'
        :raw
      else
        nil
      end
    end

    def parse_placeholder_identifier(identifier)
      identifier.split(/[\[\]\s]+/).map &:to_sym
    end

    def tag_full_name(tag)
      return tag[:name] unless tag[:namespace]

      "#{tag[:namespace]}:#{tag[:name]}".to_sym
    end

    def extract_text_mode(tag)
      tag ? tag[:text_mode] : :compact
    end

    def build_tag(parent_tag, namespace, name, flag)
      tag = {
        flag:        parse_flag(flag),
        placeholder: false,
        name:        name.to_sym,
        namespace:   namespace.try(:to_sym),
        attributes:  [],
        parent:      parent_tag
      }

      if tag[:namespace].nil? || tag[:namespace] == :html
        case tag[:name]
        when :pre
          tag[:text_mode] = :preserve
        when :code
          tag[:text_mode] = :preserve
        when :snippet
          tag[:text_mode] = :preserve
        when :textarea
          tag[:text_mode] = :preserve
        when :style
          tag[:text_mode] = :raw
        when :script
          tag[:text_mode] = :raw
        when :grammar
          tag[:text_mode] = :raw
        else
          tag[:text_mode] = extract_text_mode(parent_tag)
        end
      end

      tag
    end

    class ParserError < StandardError
      attr_accessor :position, :source_code

      def pretty_message
        return message unless @position.present? && @source_code.present?

        last_line = @source_code[0..@position].lines.count

        pretty_message = ''
        pretty_message << "ERROR: #{message.red}\n"
        pretty_message << "near line #{ last_line.to_s.red }\n"
        pretty_message << "that starts with \"#{ @source_code.lines[last_line - 1].strip.truncate(80).red }\""
        pretty_message
      end
    end
  end
end
