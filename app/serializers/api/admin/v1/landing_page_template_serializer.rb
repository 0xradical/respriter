class Api::Admin::V1::LandingPageTemplateSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :data, :layout

end
