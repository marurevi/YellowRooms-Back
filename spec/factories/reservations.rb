FactoryBot.define do
  factory :reservation do
    user
    room
    start_date { '2022-09-15' }
    end_date { '2022-09-17' }
    city { 'City' }
  end
end
