class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email
end
