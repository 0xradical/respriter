FactoryBot.define do
  factory :image do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/assets/test.jpg'), 'image/jpeg') }
  end
end

