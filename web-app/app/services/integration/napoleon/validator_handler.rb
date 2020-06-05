module Integration::Napoleon
  class ValidatorHandler
    attr_reader :raw_errors

    def initialize(raw_errors)
      @raw_errors = raw_errors
    end

    def errors
      @raw_errors.map do |error|
        case error['type']
        when 'object'           then TypeError.new(error)
        when 'array'            then TypeError.new(error)
        when 'number'           then TypeError.new(error)
        when 'string'           then TypeError.new(error)
        when 'boolean'          then TypeError.new(error)
        when 'null'             then TypeError.new(error)
        when 'integer'          then TypeError.new(error)
        when 'const'            then ConstError.new(error)
        when 'enum'             then EnumError.new(error)
        when 'type'             then MultipleTypeError.new(error)
        when 'format'           then FormatError.new(error)
        when 'minimum'          then MinimumError.new(error)
        when 'maximum'          then MaximumError.new(error)
        when 'exclusiveMinimum' then ExclusiveMinimumError.new(error)
        when 'exclusiveMaximum' then ExclusiveMaximumError.new(error)
        when 'minItems'         then MinItemsError.new(error)
        when 'maxItems'         then MaxItemsError.new(error)
        when 'pattern'          then PatternError.new(error)
        when 'multipleOf'       then MultipleOfError.new(error)
        when 'required'         then RequiredError.new(error)
        when 'uniqueItems'      then UniqueItemsError.new(error)
        when 'minLength'        then MinLengthError.new(error)
        when 'maxLength'        then MaxLengthError.new(error)
        when 'minProperties'    then MinPropertiesError.new(error)
        when 'maxProperties'    then MaxPropertiesError.new(error)

        when 'not'              then raise 'not not implemented yet'
        when 'contains'         then raise 'contains not implemented yet'
        when 'oneOf'            then raise 'oneOf not implemented yet'
        when 'contentEncoding'  then raise 'contentEncoding not implemented yet'
        when 'contentMediaType' then raise 'contentMediaType not implemented yet'
        else
          raise 'Unknown Error Type'
        end
      end
    end
  end

  class BaseError
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def field_pointer
      '#' + raw['data_pointer']
    end

    def key
      self.class.name.split('::').last.gsub(/Error$/, '').underscore
    end

    def message
      I18n.t "validations.messages.#{key}", params
    end

    def params
      {
        key:   key,
        field: field_pointer
      }
    end
  end

  class TypeError < BaseError
    def params
      super.merge type: raw['type']
    end
  end

  class MultipleTypeError < BaseError
    def params
      super.merge( types: raw['schema']['type'].join(', ') )
    end
  end

  class ConstError < BaseError
    def params
      super.merge( value: raw['schema']['const'] )
    end
  end

  class EnumError < BaseError
    def params
      super.merge( values: raw['schema']['enum'].map(&:inspect).join(', ') )
    end
  end

  class FormatError < BaseError
    def params
      super.merge( _format_: raw['schema']['format'] )
    end
  end

  class MinimumError < BaseError
    def params
      super.merge( value: raw['schema']['minimum'] )
    end
  end

  class MaximumError < BaseError
    def params
      super.merge( value: raw['schema']['maximum'] )
    end
  end

  class ExclusiveMinimumError < BaseError
    def params
      super.merge( value: raw['schema']['exclusiveMinimum'] )
    end
  end

  class ExclusiveMaximumError < BaseError
    def params
      super.merge( value: raw['schema']['exclusiveMaximum'] )
    end
  end

  class MinItemsError < BaseError
    def params
      super.merge( value: raw['schema']['minItems'] )
    end
  end

  class MaxItemsError < BaseError
    def params
      super.merge( value: raw['schema']['maxItems'] )
    end
  end

  class PatternError < BaseError
    def params
      super.merge( pattern: raw['schema']['pattern'] )
    end
  end

  class RequiredError < BaseError
    def params
      super.merge( missing_keys: raw['details']['missing_keys'].join(', ') )
    end
  end

  class MultipleOfError < BaseError
    def params
      super.merge( value: raw['schema']['multipleOf'] )
    end
  end

  class UniqueItemsError < BaseError
  end

  class MinLengthError < BaseError
    def params
      super.merge( value: raw['schema']['minLength'] )
    end
  end

  class MaxLengthError < BaseError
    def params
      super.merge( value: raw['schema']['maxLength'] )
    end
  end

  class MinPropertiesError < BaseError
    def params
      super.merge( value: raw['schema']['minProperties'] )
    end
  end

  class MaxPropertiesError < BaseError
    def params
      super.merge( value: raw['schema']['maxProperties'] )
    end
  end
end
