class Api::Admin::V1::CourseSerializer
  include FastJsonapi::ObjectSerializer

  attributes *Course.attribute_names

end

