require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /api/v1/rooms' do
    context 'when there are no rooms' do
      it 'returns a 404 status code' do
        get '/api/v1/rooms'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when there are rooms' do
      before do
        @r1 = FactoryBot.create(:room)
        @r2 = FactoryBot.create(:room)
        @r3 = FactoryBot.create(:room)
      end

      it 'returns http success' do
        get api_v1_rooms_path
        expect(response).to have_http_status(:success)
      end

      it 'returns all rooms' do
        get api_v1_rooms_path
        expect(JSON.parse(response.body)['data'].size).to eq(3)
      end

      it 'returns the correct rooms' do
        get api_v1_rooms_path
        expect(JSON.parse(response.body)['data'].map { |r| r['id'].to_i }).to match_array([@r1.id, @r2.id, @r3.id])
      end
    end
  end

  describe 'POST /api/v1/rooms' do
    context 'when the params are valid' do
      let(:valid_params) do
        { room: { name: 'Room 1', stars: 3, persons_allowed: 4, photo: 'photo_url', description: 'Description',
                  price: 100.5 } }
      end

      it 'creates a new room' do
        expect { post api_v1_rooms_path, params: valid_params }.to change(Room, :count).by(1)
      end

      it 'returns http created' do
        post api_v1_rooms_path, params: valid_params
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the params are invalid' do
      let(:invalid_params) do
        { room: { name: '', stars: 3, persons_allowed: 4, photo: 'photo_url', description: 'Description',
                  price: 100.5 } }
      end

      it 'does not create a new room' do
        expect { post api_v1_rooms_path, params: invalid_params }.to change(Room, :count).by(0)
      end

      it 'returns http unprocessable entity' do
        post api_v1_rooms_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the room is valid' do
      it 'returns http created' do
        post api_v1_rooms_path, params: { room: FactoryBot.attributes_for(:room) }
        expect(response).to have_http_status(:created)
      end

      it 'returns the room' do
        post api_v1_rooms_path, params: { room: FactoryBot.attributes_for(:room) }
        expect(JSON.parse(response.body)['data']['name']).to eq('Room 1')
      end

      it 'creates the room' do
        post api_v1_rooms_path, params: { room: FactoryBot.attributes_for(:room) }
        expect(Room.count).to eq(1)
      end
    end

    context 'when the room is invalid' do
      it 'returns http unprocessable_entity' do
        post api_v1_rooms_path, params: { room: FactoryBot.attributes_for(:room, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/rooms/:id' do
    context 'when the room exists' do
      it 'returns http ok' do
        @room = FactoryBot.create(:room)
        delete api_v1_room_path(@room)
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the room' do
        @room = FactoryBot.create(:room)
        delete api_v1_room_path(@room)
        expect(Room.find_by(id: @room.id).deleted).to be_truthy
      end

      it 'returns the correct message' do
        @room = FactoryBot.create(:room)
        delete api_v1_room_path(@room)
        expect(JSON.parse(response.body)['data']['message']).to eq('Room deleted')
      end

      it 'deletes the correct room' do
        @room = FactoryBot.create(:room)
        delete api_v1_room_path(@room)
        expect(Room.find_by(id: @room.id).deleted).to be_truthy
      end
    end
  end
end
