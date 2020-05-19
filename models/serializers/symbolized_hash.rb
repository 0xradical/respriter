module Serializers
  module SymbolizedHash
    def self.load(value)
      case value
      when Hash
        value.deep_symbolize_keys
      when Array
        value.map &:deep_symbolize_keys
      else
        value
      end
    end

    def self.dump(value)
      if value.respond_to?(:deep_stringify_keys)
        value.deep_stringify_keys
      else
        nil
      end
    end
  end
end
