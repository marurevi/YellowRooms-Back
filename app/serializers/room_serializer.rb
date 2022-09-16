class RoomSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :stars, :persons_allowed, :photo, :description, :price
end
