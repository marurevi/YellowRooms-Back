class RoomSerializer
  include JSONAPI::Serializer
  has_many :reservations
  has_many :users, through: :reservations

  attributes :id, :name, :stars, :persons_allowed, :photo, :description, :price
end
