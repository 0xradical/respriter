class Api::Admin::V1::PostSerializer
  include FastJsonapi::ObjectSerializer

  attributes *Post.attribute_names

end

