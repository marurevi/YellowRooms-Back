class UserSerializer
  include JSONAPI::Serializer
  has_many :reservations
  has_many :rooms, through: :reservations

  attributes :id, :username, :email
end
