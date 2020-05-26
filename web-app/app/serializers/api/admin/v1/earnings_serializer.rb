class Api::Admin::V1::EarningsSerializer
  include FastJsonapi::ObjectSerializer

  attributes *Earnings.attribute_names

end

