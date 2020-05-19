module Serializers
  module Pipes
    def self.load(values)
      return [] if values.blank?

      values.map do |value|
        "Pipes::#{ value.delete 'type' }".constantize.new(value.deep_symbolize_keys)
      end
    end

    def self.dump(values)
      return [] if values.blank?

      values.map do |pipe|
        pipe.options.deep_stringify_keys.merge 'type' => pipe.class.name.match(/^Pipes::/).post_match
      end
    end
  end
end
