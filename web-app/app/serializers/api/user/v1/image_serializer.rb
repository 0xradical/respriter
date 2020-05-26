class Api::User::V1::ImageSerializer
  include FastJsonapi::ObjectSerializer

  attributes :file, :caption

end
