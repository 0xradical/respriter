class Api::Admin::V1::LandingPageTemplateSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :layout

  attribute :erb_template do |object|
    object.render
  end

end
