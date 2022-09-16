class Api::V1::RoomsController < ApplicationController
  def index
    @rooms = Room.all.where(deleted: false)
    if @rooms.empty?
      render json: { message: 'No rooms found' }, status: :not_found
    else
      hash = RoomSerializer.new(Room.all.where(deleted: false)).serializable_hash
      render json: hash, status: :ok
    end
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      render json: RoomSerializer.new(@room).serializable_hash, status: :created
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.deleted = true
    if @room.save
      render json: { message: 'Room deleted' }, status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :stars, :persons_allowed, :photo, :description, :price, :deleted)
  end
end
