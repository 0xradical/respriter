module Napoleon::Path
  class Base
    delegate :each, :map, to: :all_previous_paths

    def index
      raise NotImplementedError
    end

    def traversed_distance
      raise NotImplementedError
    end

    def position
      raise NotImplementedError
    end

    def previous
      raise NotImplementedError
    end

    def estimated_distance(other_position)
      raise NotImplementedError
    end

    def estimated_to_reach(other_position)
      estimated_distance(other_position) - traversed_distance
    end

    def ways_and_tokens(&block)
      all_previous_paths.map do |path|
        yield path.way, path.token
      end
    end

    def inspect
      "#<#{self.class.name} #{position.inspect}/#{@graph.destination.inspect}>"
    end
    alias :to_s :inspect

    def details
      all_previous_paths do |path|
        puts path.inspect
      end
      nil
    end

    protected
    def all_previous_paths(&block)
      path  = self
      paths = []
      while path
        yield path if block_given?
        paths.unshift path
        path = path.previous
      end
      paths
    end
  end
end
