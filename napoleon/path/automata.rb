module Napoleon::Path
  class Automata < Napoleon::Path::Base
    attr_reader :position, :traversed_distance, :previous, :automatum, :token_index, :level

    def initialize(graph, position, traversed_distance, previous, automatum = nil, token_index = 0, level = 0)
      @graph, @position, @traversed_distance, @previous, @automatum, @token_index, @level = graph, position, traversed_distance, previous, automatum, token_index, level
    end

    def index
      [@position, @token_index].inspect.to_sym
    end

    def estimated_distance(other_position)
      distance = @graph.automata.distances[@position][other_position]
      return Float::INFINITY unless distance

      @traversed_distance + distance
    end

    def next_path(automatum)
      next_token_index, increase_level = automatum.match @graph.tokens, token_index

      return nil unless next_token_index

      next_level = @level + increase_level
      return nil if next_level < 0

      return nil if automatum.is_a?(Napoleon::Automatum::TagPlaceholderClose) && next_level != 0

      self.class.new @graph, automatum.last_state, @traversed_distance + 1, self, automatum, next_token_index, next_level
    end
  end
end
