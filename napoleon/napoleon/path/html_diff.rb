module Napoleon::Path
  class HTMLDiff < Napoleon::Path::Base
    attr_reader :position, :traversed_distance, :previous, :way, :context

    def initialize(graph, position, traversed_distance, previous = nil, way = nil)
      @graph, @position, @traversed_distance, @previous, @way = graph, position, traversed_distance, previous, way
      @context = Context.from_path self
    end

    def index
      @position.inspect.to_sym
    end

    def token
      case @way
      when :remove
        @graph.from_tokens[ @position[0] - 1 ]
      when :add
        @graph.to_tokens[ @position[1] - 1 ]
      when :keep
        @graph.to_tokens[ @position[1] - 1 ]
      else
        nil
      end
    end

    def estimated_distance(other_position)
      @traversed_distance + Math.sqrt(
        ( 4*( @position[0] - other_position[0] ) )**2 +
        ( 3*( @position[1] - other_position[1] ) )**2
      )
    end

    def next_paths(ways)
      ways.map do |way|
        if position_and_distance = perform(way)
          Napoleon::Path::HTMLDiff.new @graph, *position_and_distance, self, way
        end
      end.compact
    end

    protected
    def perform(way)
      return nil unless send(:"can_#{way}?")

      x, y = position
      case way
      when :remove
        [
          [ x + 1, y ],
          @traversed_distance + 5
          # @traversed_distance + 3
        ]
      when :add
        [
          [ x, y + 1 ],
          @traversed_distance + 5
          # @traversed_distance + 4
        ]
      when :keep
        [
          [ x + 1, y + 1 ],
          @traversed_distance + 5
        ]
      end
    end

    def from_token
      @graph.from_tokens[ @position[0] ]
    end

    def to_token
      @graph.to_tokens[ @position[1] ]
    end

    def can_remove?
      unless @position[0] < @graph.destination[0]
        return false
      end

      case from_token.type
      when :ElementOpenClose
        return @context.remove_open_tree.node == from_token.node
      when :ElementClose
        return @context.remove_open_tree.node == from_token.node
      end

      true
    end

    def can_keep?
      unless @position[0] < @graph.destination[0] &&
             @position[1] < @graph.destination[1] &&
             from_token == to_token
        return false
      end

      case to_token.type
      when :ElementOpenClose
        return @context.keep_open_tree.node == to_token.node
      when :ElementClose
        return @context.keep_open_tree.node == to_token.node
      when :AttributeName
        return @context.reading_attributes &&
               @context.open_tree.node == @context.keep_open_tree.node &&
               @context.open_tree.node == to_token.node
      when :AttributeValue
        return @context.reading_attributes &&
               @context.attribute_waiting == to_token.value[0] &&
               @context.open_tree.node == @context.keep_open_tree.node &&
               @context.open_tree.node == to_token.node
      end

      true
    end

    def can_add?
      unless @position[1] < @graph.destination[1]
        return false
      end

      case to_token.type
      when :ElementOpenClose
        return @context.add_open_tree.node == to_token.node
      when :ElementClose
        return @context.add_open_tree.node == to_token.node
      when :AttributeName
        return @context.reading_attributes &&
               @context.open_tree.node == to_token.node
      when :AttributeValue
        return @context.reading_attributes &&
               @context.attribute_waiting == to_token.value[0]
      end

      true
    end

    class Context
      attr_reader   :remove_open_tree, :keep_open_tree, :add_open_tree, :open_tree
      attr_accessor :reading_attributes, :attribute_waiting

      def initialize
        @remove_open_tree   = OpenCloseContextTree.new
        @keep_open_tree     = OpenCloseContextTree.new
        @add_open_tree      = OpenCloseContextTree.new
        @open_tree          = OpenCloseContextTree.new
        @reading_attributes = false
        @attribute_waiting  = nil
      end

      def update(way, node)
        case way
        when :remove
          @remove_open_tree = @remove_open_tree.update node
        when :add
          @add_open_tree = @add_open_tree.update node
          @open_tree     = @open_tree.update node
        when :keep
          @keep_open_tree = @keep_open_tree.update node
          @open_tree      = @open_tree.update node
        end

        self
      end

      def pop(way)
        case way
        when :remove
          @remove_open_tree = @remove_open_tree.previous
        when :add
          @add_open_tree = @add_open_tree.previous
          @open_tree     = @open_tree.previous
        when :keep
          @keep_open_tree = @keep_open_tree.previous
          @open_tree      = @open_tree.previous
        end

        self
      end

      def to_next_path(path)
        case path.token.type
        when :Element
          context = self.dup.update path.way, path.token.node
          context.reading_attributes = true if path.way != :remove
          return context
        when :ElementOpenClose
          if path.way != :remove
            context = self.dup
            context.reading_attributes = false
            context.attribute_waiting  = nil
            return context
          end
        when :ElementClose
          return self.dup.pop(path.way)
        when :AttributeName
          if path.way != :remove
            context = self.dup
            context.attribute_waiting = path.token.value
            return context
          end
        end

        self
      end

      def self.from_path(path)
        if path.previous
          path.previous.context.to_next_path path
        else
          self.new
        end
      end
    end

    class OpenCloseContextTree
      attr_reader :previous, :node

      def initialize(previous = nil, node = nil)
        @previous, @node = previous, node
      end

      def update(node)
        self.class.new self, node
      end
    end
  end
end
