class Api::Admin::V1::ProviderSerializer
  include FastJsonapi::ObjectSerializer

  attributes *Provider.attribute_names

end

