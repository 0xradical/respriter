class Api::Admin::V1::LandingPageSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :slug, :html, :data

end

