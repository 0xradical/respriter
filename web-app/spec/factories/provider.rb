FactoryBot.define do
  factory :provider do
    sequence :name do |n|
      "Provider #{n}"
    end
  end
end
