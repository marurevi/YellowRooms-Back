FactoryBot.define do
  factory :reservation do
    user
    room
    start_date { Date.today }
    end_date { Date.tomorrow }
    city { 'City' }
  end
end
