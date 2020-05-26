FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "How to prepare a delicious cucumber salad #{n}" }
    sequence(:url)  { name.parameterize }
    published       { true }
    certificate     { { type: :included } }
    offered_by      { nil }
    provider
  end
end
