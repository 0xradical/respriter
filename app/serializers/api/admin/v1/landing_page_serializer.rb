class Api::Admin::V1::LandingPageSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :slug, :layout, :erb_template, :data

end
