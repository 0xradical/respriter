module Napoleon
  module Graph
    class Base
      delegate :search, :search!, :last_path, to: :a_star

      def next_paths(path)
        raise NotImplementedError
      end

      def destination
        raise NotImplementedError
      end

      def source_path
        raise NotImplementedError
      end

      def finished?(path)
        path.position == destination
      end

      def inspect
        "#<#{self.class.name} #{destination.inspect}>"
      end
      alias :to_s :inspect

      protected
      def a_star
        @a_star ||= Napoleon::Search::AStar.new(self)
      end
    end
  end
end
