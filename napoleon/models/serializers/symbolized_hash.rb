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
      case value
      when String
        dump_string(value)
      when Hash
        dump_hash(value)
      when Array
        dump_array(value)
      else
        value
      end
    end

    def self.dump_string(value)
      value.delete("\0").chars.select(&:valid_encoding?).join
    end
    
    def self.dump_hash(value)
      value.map{|k,v| [dump(k), dump(v)]}.to_h.deep_stringify_keys
    end

    def self.dump_array(value)
      value.map{|k| dump(k)}
    end
  end
end
