class Api::Admin::V1::UserAccountSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :email, :created_at, :updated_at

end

