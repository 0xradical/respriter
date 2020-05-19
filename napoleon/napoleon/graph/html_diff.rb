module Napoleon::Graph
  class HTMLDiff < Napoleon::Graph::Base
    attr_reader :from_tokens, :to_tokens, :destination, :options

    DEFAULT_WAYS = [ :add, :remove, :keep ]

    def initialize(from_tokens, to_tokens, options = { ways: DEFAULT_WAYS })
      @from_tokens, @to_tokens, @options = from_tokens, to_tokens, options
      @destination = [ @from_tokens.size, @to_tokens.size ]
    end

    def next_paths(path)
      path.next_paths @options[:ways]
    end

    def source_path
      Napoleon::Path::HTMLDiff.new self, [0,0], 0
    end
  end
end
