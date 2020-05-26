class Api::Admin::V1::ProfileSerializer
  include FastJsonapi::ObjectSerializer

  attributes :preferences

end

