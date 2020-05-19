require 'csv'

class ResourceApp < BaseApp
  RESOURCE_UPDATE_SIZE = 50

  use Rack::Auth::Basic, 'Authentication Required' do |username, password|
    User.authenticated? username, password
  end

  get '/resources/updates/?:cursor?' do
    cursor = params[:cursor] || 0

    versions = ResourceVersion
      .where('dataset_sequence > ?', cursor)
      .order( :dataset_sequence )
      .limit(RESOURCE_UPDATE_SIZE)

    json versions.as_json
  end

  get '/resources/:resource_id/updates/?:cursor?' do
    cursor = params[:cursor] || 0

    versions = ResourceVersion
      .where( params.slice :resource_id )
      .where( 'sequence > ?', cursor    )
      .order( :id )
      .limit(RESOURCE_UPDATE_SIZE)

    json versions.as_json
  end
end
