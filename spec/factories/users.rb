FactoryBot.define do
  factory :user do
    sequence(:username, 'a') do |n|
      "JhonDoe#{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { 'password' }
  end
end
