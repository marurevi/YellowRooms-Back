class ReservationSerializer
  include JSONAPI::Serializer
  belongs_to :room

  attributes :id, :user_id, :room_id, :start_date, :end_date, :city
end
