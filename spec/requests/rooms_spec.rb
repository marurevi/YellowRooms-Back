require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /api/v1/rooms' do
    before { get api_v1_rooms_path }
    context 'when there are no rooms' do
      it 'returns a 404 status code' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when there are rooms' do
      before do
        @r1 = FactoryBot.create(:room)
        @r2 = FactoryBot.create(:room)
        @r3 = FactoryBot.create(:room)
        get api_v1_rooms_path
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all rooms' do
        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(3)
      end

      it 'returns the correct rooms' do
        data = JSON.parse(response.body)['data']
        expect(data.map { |r| r['id'].to_i }).to match_array([@r1.id, @r2.id, @r3.id])
      end
    end
  end

  describe 'POST /api/v1/rooms' do
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

    context 'when the params are valid' do
      before do
        post api_v1_rooms_path, params: { room: FactoryBot.attributes_for(:room) }
      end
      it 'returns http created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the room' do
        expect(JSON.parse(response.body)['data']['name']).to eq('Room 1')
      end

      it 'creates the room' do
        expect(Room.count).to eq(1)
      end
    end
  end

  describe 'DELETE /api/v1/rooms/:id' do
    before do
      @room = FactoryBot.create(:room)
      delete api_v1_room_path(@room.id)
    end

    context 'when the room exists' do
      it 'returns http ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the room' do
        expect(Room.find(@room.id).deleted).to be_truthy
      end

      it 'returns the correct message' do
        data = JSON.parse(response.body)['data']
        expect(data['message']).to eq('Room deleted')
      end

      it 'deletes the correct room' do
        expect(Room.find(@room.id).deleted).to be_truthy
      end
    end
  end
end
