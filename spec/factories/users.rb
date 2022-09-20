FactoryBot.define do
  factory :user do
    username { 'JhonDoe' }
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { 'password' }
  end
end
