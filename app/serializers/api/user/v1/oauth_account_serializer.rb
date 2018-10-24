class Api::User::V1::OauthAccountSerializer
  include FastJsonapi::ObjectSerializer

  attribute :provider

end
