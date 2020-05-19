module Napoleon
  class Automata
    attr_reader :states, :first_state, :last_state

    def initialize(ast)
      @states              = []
      @first_state         = new_state
      @last_state          = new_state
      @states[@last_state] = :finished

      add_nodes @first_state, @last_state, ast
    end

    def dump
      distances
      Zlib.deflate Marshal.dump(self)
    end

    def self.load(dump)
      return nil unless dump
      Marshal.load Zlib.inflate(dump)
    end

    def self.dump(automata)
      return nil unless automata
      automata.dump
    end

    def as_json(**opts)
      {
        first_state: first_state,
        last_state:  last_state,
        states:      states
      }
    end

    def next_states(state)
      @states[state]
    end

    def distances
      @distances ||= min_distances
    end

    protected
    def min_distances
      transposed_states = []
      @states.flatten.each do |state|
        next if state.is_a?(Symbol)
        transposed_states[state.last_state] ||= []
        transposed_states[state.last_state].push state.first_state
      end
      distances = Hash.new{ |h,i| Float::INFINITY }

      distances[@last_state] = 0

      to_be_evaluated = [ [@last_state, 0] ]
      until to_be_evaluated.empty?
        target, traversed_distance = to_be_evaluated.shift

        next unless transposed_states[target]
        transposed_states[target].each do |previous|
          if distances[previous] > traversed_distance+1
            distances[previous] = traversed_distance+1
            to_be_evaluated.push [previous, traversed_distance+1]
          end
        end
      end

      relevant_distances = Hash.new
      distances.each do |i, distance|
        relevant_distances[i] ||= Hash.new
        relevant_distances[i][@last_state] = distance

        relevant_distances[@last_state] ||= Hash.new
        relevant_distances[@last_state][i] = distance
      end
      relevant_distances
    end

    def add_nodes(first_state, last_state, nodes)
      return nil if nodes.empty?

      current_first_state = first_state
      current_last_state  = nil

      nodes[0..-2].each do |type, data|
        current_last_state = new_state
        build_automatum current_first_state, current_last_state, type, data
        current_first_state = current_last_state
      end

      type, data = nodes[-1]
      build_automatum current_first_state, last_state, type, data
    end

    def add_automatum(automatum)
      @states[automatum.first_state] << automatum
      automatum.last_state
    end

    def multiple_flag?(flag)
      flag == :one_or_more || flag == :zero_or_more
    end

    def build_automatum(first_state, last_state, type, data)
      case type
      when :tag
        build_tag_automatum data, first_state, last_state
      when :text
        add_automatum Automatum::Text.new(first_state, last_state, data)

        if data.gsub(/\s+/, ' ').strip.blank?
          add_automatum Automatum::Empty.new(first_state, last_state)
        end
      when :processing_instruction
        add_automatum Automatum::ProcessingInstruction.new(first_state, last_state, data)
      when :doctype
        add_automatum Automatum::Doctype.new(first_state, last_state, data)
      when :cdata
        add_automatum Automatum::CDATA.new(first_state, last_state, data)
      when :comment
        add_automatum Automatum::Comment.new(first_state, last_state, data)
      when :tag_placeholder
        if data[:singleton]
          build_singleton_tag_placeholder_automatum data, first_state, last_state
        else
          build_tag_placeholder_automatum data, first_state, last_state
        end
      end
    end

    def build_tag_automatum(data, first_state, last_state)
      iterates = data[:iterator].present?
      multiple = multiple_flag? data[:flag]

      if iterates
        params = { id: new_id, identifier: data[:iterator] }
        first_state = add_automatum Automatum::TagPlaceholder.new(first_state, new_state, params.merge(multiple: multiple))
        last_state  = new_state{ |state| add_automatum Automatum::TagPlaceholderClose.new(state, last_state, params) }
      end

      first_state, last_state = states_for_flags data[:flag], first_state, last_state

      next_state = first_state
      if iterates
        next_state = add_automatum Automatum::IteratorStart.new(next_state, new_state)
      end

      name   = data[:namespace].present? ? data[:namespace] : "#{data[:namespace]}:#{data[:name]}".to_sym
      params = { id: new_id, name: name }

      next_state = add_automatum Automatum::Tag.new(next_state, new_state, params.merge(multiple: multiple))

      if data[:attributes].present?
        next_state = add_automatum Automatum::Attributes.new(next_state, new_state, data[:attributes])
      end

      next_state = add_automatum Automatum::CloseOpenTag.new(next_state, new_state, params)

      if data[:children].present?
        next_state = new_state{ |state| add_nodes next_state, state, data[:children] }
      end

      if iterates
        next_state = add_automatum Automatum::CloseTag.new(next_state, new_state, params)
        next_state = add_automatum Automatum::IteratorClose.new(next_state, last_state)
      else
        next_state = add_automatum Automatum::CloseTag.new(next_state, last_state, params)
      end
    end

    def build_singleton_tag_placeholder_automatum(data, first_state, last_state)
      first_state, last_state = states_for_flags data[:flag], first_state, last_state

      single_content = if data[:store].size == 1
        store = data[:store].first
        store == :text || store == :comment || store == :cdata
      end

      params = {
        id:             new_id,
        singleton:      true,
        identifier:     data[:identifier],
        single_content: single_content
      }

      new_first_state = add_automatum Automatum::TagPlaceholder.new(first_state, new_state, params)
      new_last_state  = new_state
      add_automatum Automatum::TagPlaceholderClose.new(new_last_state, last_state, params)

      build_placeholder_capture_automaum single_content, data[:store], new_first_state, new_last_state
    end

    def build_placeholder_capture_automaum(single_content, stores, first_state, last_state)
      unless single_content
        last_state = new_state do |state|
          add_automatum Automatum::Empty.new(state, first_state)
          add_automatum Automatum::Empty.new(state, last_state)
          add_automatum Automatum::Text.new(state, last_state, '')
        end
      end

      stores.each do |store|
        case store
        when :text
          add_automatum Automatum::TextCapture.new(first_state, last_state)
        when :comment
          add_automatum Automatum::CommentCapture.new(first_state, last_state)
        when :processing_instruction
          add_automatum Automatum::DTDCapture.new(first_state, last_state)
        when :cdata
          add_automatum Automatum::CDATACapture.new(first_state, last_state)
        when :doctype
          add_automatum Automatum::DoctypeCapture.new(first_state, last_state)
        else
          add_automatum Automatum::TagCapture.new(first_state, last_state, store)
          add_automatum Automatum::CloseTagCapture.new(first_state, last_state)
        end
      end
    end

    def build_tag_placeholder_automatum(data, first_state, last_state)
      multiple = multiple_flag? data[:flag]

      params = { id: new_id, identifier: data[:identifier] }
      first_state = add_automatum Automatum::TagPlaceholder.new(first_state, new_state, params.merge(multiple: multiple))
      last_state  = new_state{ |state| add_automatum Automatum::TagPlaceholderClose.new(state, last_state, params) }

      first_state, last_state = states_for_flags data[:flag], first_state, last_state

      if multiple
        first_state = add_automatum Automatum::IteratorStart.new(first_state, new_state)
        last_state  = new_state{ |state| add_automatum Automatum::IteratorClose.new(state, last_state) }
      end

      if data[:children].present?
        add_nodes first_state, last_state, data[:children]
      else
        add_automatum Automatum::Empty.new(first_state, last_state)
      end
    end

    def states_for_flags(flag, first_state, last_state)
      case flag
      when :optional
        new_first_state = new_state
        add_automatum Automatum::Empty.new( first_state, last_state      )
        add_automatum Automatum::Empty.new( first_state, new_first_state )
        [new_first_state, last_state]
      when :zero_or_more
        new_first_state = new_state
        new_last_state  = new_state
        add_automatum Automatum::Empty.new( first_state,    last_state      )
        add_automatum Automatum::Empty.new( first_state,    new_first_state )
        add_automatum Automatum::Empty.new( new_last_state, last_state      )
        add_automatum Automatum::Empty.new( new_last_state, new_first_state )
        add_automatum Automatum::Text.new(new_last_state, new_first_state, ' ')
        [new_first_state, new_last_state]
      when :one_or_more
        new_last_state = new_state
        add_automatum Automatum::Empty.new( new_last_state, last_state  )
        add_automatum Automatum::Empty.new( new_last_state, first_state )
        add_automatum Automatum::Text.new(new_last_state, first_state, ' ')
        [first_state, new_last_state]
      else # required
        [first_state, last_state]
      end
    end

    def new_id
      SecureRandom.hex 16
    end

    def new_state(&block)
      new_index = @states.size
      @states.push []
      yield(new_index) if block_given?
      new_index
    end
  end
end
