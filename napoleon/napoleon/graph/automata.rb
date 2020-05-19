module Napoleon::Graph
  class Automata < Napoleon::Graph::Base
    attr_reader :automata, :tokens

    def initialize(automata, tokens)
      @automata, @tokens = automata, tokens
    end

    def destination
      @automata.last_state
    end

    def next_paths(path)
      @automata.next_states(path.position).map do |automatum|
        path.next_path automatum
      end.compact
    end

    def extract_data
      return nil unless last_path

      context = HashContext.new
      last_path.map(&:itself).each_cons(2) do |path, next_path|
        automatum      = next_path.automatum
        matched_tokens = @tokens[path.token_index..(next_path.token_index-1)]
        context = automatum.extract_data context, matched_tokens
      end
      context.data
    end

    def search!
      super
    rescue Napoleon::Search::NotFoundError => error
      error.graph      = self
      error.last_token = @tokens[error.closest_path.token_index]
      raise error
    end

    def source_path
      Napoleon::Path::Automata.new self, @automata.first_state, 0, nil
    end

    class ArrayContext
      attr_reader :data, :parent, :index

      def initialize(data, parent = nil)
        @data, @parent = data, parent
        @index = @data.size
      end

      def set(value)
        @data[@index] ||= []
        @data[@index] << value
      end

      def next_context(next_identifiers, options)
        next_data = @data[@index] ||= Hash.new
        HashContext.new next_data, next_identifiers, self, options
      end
    end

    class HashContext
      attr_reader :data, :parent, :identifiers, :multiple, :single_content

      def initialize(data = Hash.new, identifiers = nil, parent = nil, multiple: false, single_content: false, **opts)
        @data, @identifiers, @parent, @multiple, @single_content = data, identifiers, parent, multiple, single_content
        set([]) if @multiple
      end

      def value
        @identifiers[0..-2].inject(@data) do |data, id|
          data[id] ||= Hash.new
        end[ @identifiers[-1] ]
      end

      def replace(replaced_value)
        data = @identifiers[0..-2].inject(@data) do |data, id|
          data[id] ||= Hash.new
        end

        raw_data = data[ @identifiers[-1] ]
        data[ @identifiers[-1] ] = replaced_value
      end

      def next_context(next_identifiers, options)
        next_data = if @identifiers.present? && @identifiers != [:~]
          @identifiers.inject(@data) do |data, id|
            data[id] ||= Hash.new
          end
        else
          @data
        end

        HashContext.new next_data, next_identifiers, self, options
      end

      def iterated_context
        next_data = @identifiers.inject @data, &:[]
        ArrayContext.new next_data, self
      end

      def set(value)
        return if @identifiers == [:~]

        data = @identifiers[0..-2].inject(@data) do |data, id|
          data[id] ||= Hash.new
        end

        if @single_content || @multiple
          data[ @identifiers[-1] ] = value
        else
          data[ @identifiers[-1] ] ||= Array.new
          data[ @identifiers[-1] ] << value
        end
      end
    end
  end
end
