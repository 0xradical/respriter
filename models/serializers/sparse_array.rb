module Serializers
  module SparseArray
    def self.load(value)
      return Hash.new(0) if value.blank?

      hash = (0..(value.size-1)).zip(value).to_h
      hash.default = 0
      hash
    end

    def self.dump(value)
      return [] if value.blank?

      (value.keys.max + 1).times.map do |index|
        value[index]
      end
    end
  end
end
