require 'csv'

class SchemaApp < BaseApp
  get '/schemas/:kind/:schema_version' do
    cursor = params[:cursor] || 0

    version = ResourceSchema.find_by! params.slice(:kind, :schema_version)

    json version.public_specification
  end
end
