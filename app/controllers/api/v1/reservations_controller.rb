class Api::V1::ReservationsController < ApplicationController
  def index
    @reservations = Reservation.all
    if @reservations.empty?
      render json: { error: "Couldn't find Reservation" }, status: :not_found
    else
      hash = ReservationSerializer.new(@reservations).serializable_hash[:data].map do |data|
        data[:attributes]
      end
      render json: { code: 200, data: hash }, status: :ok
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      hash = ReservationSerializer.new(@reservation).serializable_hash[:data][:attributes]
      render json: { code: 201, data: hash }, status: :created
    else
      render json: { code: 422, data: { errors: @reservation.errors.full_messages.to_sentence } },
             status: :unprocessable_entity
    end
  end

  def destroy
    @reservation = Reservation.find_by(id: params[:id])
    if @reservation.nil?
      render json: { error: "Couldn't find Reservation with 'id'=#{params[:id]}" }, status: :not_found
    elsif @reservation.destroy
      render json: { code: 200, data: { message: 'Reservation deleted' } }, status: :ok
    else
      render json: { code: 422, data: { errors: @reservation.errors.full_messages.to_sentence } },
             status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :user_id, :room_id, :city)
  end
end
