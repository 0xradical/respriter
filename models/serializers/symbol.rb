module Serializers
  module Symbol
    def self.load(value)
      value.nil? ? nil : value.to_sym
    end

    def self.dump(value)
      value.nil? ? nil : value.to_s
    end
  end
end
