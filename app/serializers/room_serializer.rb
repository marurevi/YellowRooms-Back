class RoomSerializer
  include JSONAPI::Serializer
  has_many :reservations

  attributes :id, :name, :stars, :persons_allowed, :photo, :description, :price
end
