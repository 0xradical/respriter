class Api::User::V1::ProfileSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :avatar, :preferences, :interests

end
