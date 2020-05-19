module Napoleon
  class HTMLToken
    attr_reader :node, :type, :value, :options

    def initialize(node, type, value, **options)
      @node, @type, @value, @options = node, type, value, options
    end

    def ==(other)
      other && @type == other.type && @value == other.value
    end

    def inspect
      "#<#{type}: #{value}>"
    end
    alias :to_s :inspect
  end
end
