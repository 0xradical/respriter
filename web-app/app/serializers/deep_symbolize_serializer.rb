require 'strscan'

module DeepSymbolizeSerializer

  def self.load(value)
    return nil if value.nil?
    value.deep_symbolize_keys
  end

  def self.dump(value)
    return nil if value.nil?
    value.deep_stringify_keys
  end
end
