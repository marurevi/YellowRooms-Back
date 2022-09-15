FactoryBot.define do
  factory :room do
    name { 'Room 1' }
    stars { 3 }
    persons_allowed { 4 }
    photo { 'photo_url' }
    description { 'Description' }
    price { 100.5 }
  end
end
