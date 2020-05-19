module Napoleon::Search
  class AStar < Napoleon::Search::Base

    def search!
      @last_path = nil
      traversor = Traversor.new @graph.destination

      traversor.push_if_not_traversed @graph.source_path

      loop do
        path = traversor.pop

        raise NotFoundError.new(traversor.closest_path) unless path

        if @graph.finished?(path)
          @last_path = path
          return path
        end

        @graph.next_paths(path).each do |next_path|
          traversor.push_if_not_traversed next_path
        end
      end
    end

    def search
      search!
    rescue NotFoundError
      nil
    end

    class Traversor
      attr_reader :closest_path

      def initialize(destination)
        @destination = destination

        @reached_tokens = Set.new
        @next_paths     = Containers::MinHeap.new
      end

      def pop
        @next_paths.pop
      end

      def push_if_not_traversed(path)
        unless @reached_tokens.include?(path.index)
          @reached_tokens.add path.index
          @next_paths.push path.estimated_distance(@destination), path

          if @closest_path.nil? || path.token_index > @closest_path.token_index
            @closest_path = path
          end
        end
      end
    end
  end
end
