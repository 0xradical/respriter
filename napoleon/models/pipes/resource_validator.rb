module Pipes
  class ResourceValidator < Pipe
    include SchemaValidation

    # default configuration
    # can be overriden via accumulator or options
    schema_validate :course_name,
                    :description,
                    :pace,
                    :published,
                    :slug,
                    :url,
                    :prices,
                    :level,
                    :version,
                    presence: true, format: true

    schema_validate :rating,
                    :duration,
                    :effort,
                    :free_content,
                    :paid_content,
                    :instructors,
                    :language,
                    :pace,
                    :offered_by,
                    :audio,
                    :subtitles,
                    :video,
                    presence: false, format: true

    def execute(pipe_process, accumulator)
      params = default_params.deep_cumulative_merge(options.deep_symbolize_keys, :fields)
                             .deep_cumulative_merge(accumulator.deep_symbolize_keys, :fields)

      validation = schema_validate(
        params&.[](:content),
        params&.[](:validator)&.delete(:fields),
        params&.[](:validator)
      )

      if validation.empty?
        [ :pending, accumulator ]
      else
        [ :failed, validation_errors: validation ]
      end
    end

    protected

    def default_params
      {
        validator: {
          # passing this as true overrides the fields / schema_validate configs
          # and all fields described in schema.json are validated
          everything: false,
          fields: [
            # [:video, presence: true], # pass an array with options
            # :rating, # or simply the field name (options will default to what's defined in SchemaValidation)
          ]
        }
      }
    end
  end
end