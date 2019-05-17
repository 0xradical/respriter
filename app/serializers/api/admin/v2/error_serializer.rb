module Api
  module Admin
    module V2
      class ErrorSerializer

        attr_reader :object

        def initialize(object)
          @object = object
        end

        def serialize
          { errors: object.errors.messages.map do |field, errors|
            errors.map do |error_message|
              {
                source: {
                  pointer: "/data/attributes/#{field}"
                },
                attribute: field,
                detail: error_message
              }
            end
          end.flatten }
        end

        def to_json(opts = {})
          serialize.to_json
        end

      end
    end
  end
end
