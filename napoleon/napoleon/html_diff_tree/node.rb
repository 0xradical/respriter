module Napoleon::HTMLDiffTree
  class Node
    # TODO: Think about Node's tokens
    def tokens
      @tokens ||= Napoleon::HTMLTokenCollection.new self
    end

    def children
      @children ||= []
    end

    def name
      demodulized_class_name
    end
    alias :value :name

    def inspect
      "#<#{ demodulized_class_name }:#{value} [#{children.map(&:inspect).join ', '}]>"
    end

    def subscribe_token_collection(collection)
      collection << Napoleon::HTMLToken.new(self, name, value)
      children.each do |node|
        node.subscribe_token_collection collection
      end
    end

    def demodulized_class_name
      self.class.name.demodulize.to_sym
    end
  end
end
