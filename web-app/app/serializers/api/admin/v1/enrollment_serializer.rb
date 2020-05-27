class Api::Admin::V1::EnrollmentSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :tracked_url, :tracking_data, :created_at, :updated_at

end
