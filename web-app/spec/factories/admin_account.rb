FactoryBot.define do
  factory :admin_account do
    sequence(:email) { |n| "admin-#{n}@classpert.com" }
    password { "classert@123" }
  end
end
