module Pipes
  class ResourceCreator < Pipe
    ATTRIBUTES = [:kind, :schema_version, :status, :unique_id, :content, :relations, :dataset_id, :last_execution_id]

    # TODO: Handle those use cases:
    #       * replace a hash instead of deep merging it
    #       * add/remove values from an array
    def execute(pipe_process, accumulator)
      params = default_params(pipe_process)
        .merge(options)
        .deep_merge(accumulator.deep_symbolize_keys)
        .slice(*ATTRIBUTES)

      validator = find_validator *params.values_at(:dataset_id, :kind, :schema_version)

      if validator.present?
        validated_content = params[:content].deep_dup.deep_stringify_keys
        errors = validator.validate validated_content

        if errors.any?
          parsed_errors = {
            type:   'validation_error',
            errors: errors.map{ |error| error.except 'root_schema' },
            keys:   errors.map{ |error| error['data_pointer'] }.uniq.sort
          }

          return [
            :failed,
            parsed_errors
          ]
        else
          params[:content] = validated_content.deep_symbolize_keys
        end
      end

      results = ApplicationRecord.connection.execute query(params)

      [
        :pending,
        { id: results.first['id'] }
      ]
    end

    protected
    def find_validator(dataset_id, kind, version)
      schema = ResourceSchema.where(dataset_id: dataset_id, kind: kind, schema_version: version).first
      return nil unless schema

      JSONSchemer.schema schema.specification, insert_property_defaults: true
    end

    def query(params)
      keys = params.keys
      raise 'Invalid keys' unless keys.all?{ |key| key.match /^\w[\w\d]*$/ }

      values = keys.map do |key|
        value = params[key]
        case value
        when String
          ApplicationRecord.sanitize_sql ['?', value]
        when Symbol
          ApplicationRecord.sanitize_sql ['?', value]
        when Hash
          ApplicationRecord.sanitize_sql ['?::jsonb', value.to_json]
        when Numeric
          ApplicationRecord.sanitize_sql ['?', value]
        else
          raise "Invalid value at #{key}"
        end
      end

      sanitized_params = keys.zip(values).to_h

      update_clause = sanitized_params
        .except(:dataset_id, :unique_id, :kind)
        .map do |key, value|
          if params[key].is_a?(Hash)
            # TODO: Change it for util.jsonb_merge
            "#{key} = app.jsonb_merge(resources.#{key}, EXCLUDED.#{key})"
          else
            "#{key} = #{value}"
          end
        end
        .join ",\n"

      %{
        INSERT INTO resources
          (#{ keys.join ', ' })
        VALUES
          (#{ values.join ', ' })
        ON CONFLICT
          (dataset_id, unique_id, kind)
        DO
          UPDATE
          SET #{update_clause}
          RETURNING id
        ;
      }
    end

    def default_params(pipe_process)
      {
        status:            :active,
        dataset_id:        pipe_process.pipeline.dataset_id,
        last_execution_id: pipe_process.pipeline.pipeline_execution_id
      }
    end
  end
end
