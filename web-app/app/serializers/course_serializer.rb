class CourseSerializer
  include FastJsonapi::ObjectSerializer
  attributes *Course.attribute_names
end
