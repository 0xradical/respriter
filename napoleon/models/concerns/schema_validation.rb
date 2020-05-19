module SchemaValidation
  extend ActiveSupport::Concern

  def schema_validate(content, fields, validator_options)
    self.class.run_validator(content, fields, validator_options)
  end

  class_methods do
    def schema_json
      @schema_json ||= File.read(File.join(NapoleonApp.root, 'schema.json'))
    end

    def schema_validation_defaults
      { presence: false, format: true }
    end

    def default_schema_config
      @default_schema_config ||= {}
    end

    # default options for fields
    # presence: false
    #   all fields are optional and may not appear in content
    # format: true
    #   all fields are validated against its format described in schema.json
    # presence: false, format: false
    #   I don't care at all
    # presence: false, format: true
    #   I only care if this field is in a valid format, ignore its validation
    #   if it's not an existing property in content
    # presence: true,  format: false
    #   I only care if this field is an existing property in content
    # presence: true,  format: true
    #   I double care: the field has to be an existing property in content and has to be valid
    def schema_validate(*fields, **options)
      fields.each do |field|
        default_schema_config[field] = schema_validation_defaults.merge(options)
      end
    end

    def build_schema_config(fields)
      schema_config = default_schema_config.dup.tap{|h| h.default = Hash.new}
      if fields&.size&.>(0)
        fields.each do |field|
          case field
          when Array
            field, options = field
          else
            options = schema_validation_defaults
          end

          schema_config[field] = schema_config[field].merge(options)
        end
      end
      schema_config
    end

    def run_validator(content, fields, validator_options)
      schema_config = self.build_schema_config(fields)
      options       = { errors_as_objects: true }.merge(validator_options.to_h).deep_symbolize_keys
      schema        = JSON.load(self.schema_json).tap do |s|
        if options[:everything]
          s['required'] = s['properties'].keys
        else
          s['required'] = schema_config.select do |_field,opts|
            opts[:presence]
          end.keys
        end
      end

      JSON::Validator.fully_validate(schema, content, options).inject(Hash.new) do |errors, error|
        _, field, *extra = error[:fragment].split("/")
        details          = error[:message].match(/The property '#{error[:fragment]}' (?<details>.*) in schema .*/)&.[](:details)
        property         = error[:message].match(/did not contain a required property of '(?<property>[^']+)'/)&.[](:property)
        field            = field&.to_sym || :root

        if (field == :root) && property
          errors[field]  ||= []
          errors[field] << { value: property, details: details, extra: extra }
        end

        if (field != :root) && (options[:everything] || schema_config[field]&.[](:format))
          errors[field]  ||= []
          errors[field] << { value: content[field], details: details, extra: extra }
        end

        errors
      end
    end
  end
end
