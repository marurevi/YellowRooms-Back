FactoryBot.define do
  factory :user do
    username { 'Jhon Doe' }
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { 'password' }
  end
end
