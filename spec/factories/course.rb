FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "How to prepare a delicious cucumber salad #{n}" }
    sequence(:url)  { |n| "how-to-prepare-a-delicious-cucumber-salad-#{n}" }
    published { true }
    certificate { { type: :included } }
    provider
  end
end

