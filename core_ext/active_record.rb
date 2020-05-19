module ActiveRecord
  module Type
    class Json < ActiveModel::Type::Value
      def deserialize(value)
        return value unless value.is_a?(::String)
        Oj.load(value)
      end

      def serialize(value)
        Oj.dump(value) unless value.nil?
      end
    end
  end
end
