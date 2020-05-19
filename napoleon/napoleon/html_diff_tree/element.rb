module Napoleon::HTMLDiffTree
  class Element < Node
    attr_reader :name, :attributes, :options

    def initialize(name, attributes, **options)
      @name, @attributes, @options = name, attributes.to_a.sort.map{ |k,v| [ k, v.text ] }, options

      @attributes_lines = attributes.to_a.sort.map{ |k,v| [ k, v.line ] }.to_h
    end

    def set_attribute(name, value = nil)
      raise("Duplicated attribute #{Hash[@attributes][name]}") if Hash[@attributes][name]

      (hash_attributes = Hash[@attributes])[name] ||= value
      @attributes = hash_attributes.to_a.sort_by &:first
    end

    def subscribe_token_collection(collection)
      collection << Napoleon::HTMLToken.new(self, :Element, name, @options)

      attributes.each do |attr_name, attr_value|
        attr_options = { line: @attributes_lines[attr_name] }
        collection << Napoleon::HTMLToken.new(self, :AttributeName, attr_name, attr_options)

        if attr_value
          collection << Napoleon::HTMLToken.new(self, :AttributeValue, [attr_name, attr_value], attr_options)
        end
      end

      collection << Napoleon::HTMLToken.new(self, :ElementOpenClose, name, @options)

      children.each do |node|
        node.subscribe_token_collection collection
      end

      collection << Napoleon::HTMLToken.new(self, :ElementClose, name, @options)
    end

    def to_lmth(lmth, level, parent)
      padding = "\n" + ('  ' * level)
      lmth << padding if level > 0
      lmth << '<'
      lmth << name

      attributes.each do |attr_name, attr_value|
        lmth << " #{attr_name}=\"#{attr_value.gsub '"', '\"'}\""
      end

      if children.empty?
        lmth << '/>'
        return lmth
      end
      lmth << '>'

      children.each do |child|
        child.to_lmth lmth, level+1, self
      end

      lmth << padding unless children.size == 1 && children.first.is_a?(Napoleon::HTMLDiffTree::Text) && children.first.value.size <= 60
      lmth << "</#{name}>"
      lmth
    end
  end
end
