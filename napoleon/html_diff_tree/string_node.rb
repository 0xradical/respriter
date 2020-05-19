module Napoleon::HTMLDiffTree
  class StringNode < Node
    attr_reader :value

    def initialize(value, **options)
      @value, @options = value, options
    end

    def subscribe_token_collection(collection)
      collection << Napoleon::HTMLToken.new(self, name, value, @options)
    end

    def to_lmth(lmth, level, parent)
      if value.size > 60
        padding = "\n" + ('  ' * level)
        lmth << padding
      end

      lmth << value.gsub('<', '\<')
      lmth
    end
  end
end
