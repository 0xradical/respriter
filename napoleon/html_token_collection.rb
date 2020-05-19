module Napoleon
  class HTMLTokenCollection < Array
    attr_reader :root_node

    def initialize(root_node = nil)
      @root_node = root_node
      @root_node.subscribe_token_collection(self) if @root_node
    end

    def marshal_dump
      @root_node
    end

    def marshal_load(value)
      @root_node = value
      @root_node.subscribe_token_collection(self) if @root_node
    end

    def self.[](*tokens)
      self.new build_root(tokens)
    end

    def self.build_root(tokens)
      root_node = nil
      parent_stack = Array.new
      reading_attributes = false
      tokens.each do |token|
        case token.type
        when :Document
          root_node = HTMLDiffTree::Document.new
          parent_stack.push root_node
        when :Element
          element = HTMLDiffTree::Element.new(token.value, [])
          parent_stack.last.children << element
          parent_stack.push element
          reading_attributes = true
        when :AttributeName
          raise 'Should be reading attributes' unless reading_attributes
          parent_stack.last.set_attribute token.value
        when :AttributeValue
          raise 'Should be reading attributes' unless reading_attributes
          parent_stack.last.set_attribute *token.value
        when :ElementOpenClose
          reading_attributes = false
        when :ElementClose
          parent_stack.pop
        when :CDATA
          parent_stack.last.children << HTMLDiffTree::CDATA.new(token.value)
        when :Comment
          parent_stack.last.children << HTMLDiffTree::Comment.new(token.value)
        when :Text
          parent_stack.last.children << HTMLDiffTree::Text.new(token.value)
        end
      end
      root_node
    end
  end
end
