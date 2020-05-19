class Array
  def deep_symbolize_keys
    self.map do |element|
      if element.respond_to?(:deep_symbolize_keys)
        element.deep_symbolize_keys
      else
        element
      end
    end
  end

  def deep_stringify_keys
    self.map do |element|
      if element.respond_to?(:deep_stringify_keys)
        element.deep_stringify_keys
      else
        element
      end
    end
  end
end
