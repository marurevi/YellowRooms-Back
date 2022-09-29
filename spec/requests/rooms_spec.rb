require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  let(:user) { create(:user) }
  let(:headers) { generate_jwt_token_for(user) }

  describe 'GET /api/v1/rooms' do
    before { get api_v1_rooms_path, headers: }
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
        get api_v1_rooms_path, headers:
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
    context 'passing invalid parameters' do
      let(:invalid_params) do
        { name: '', stars: 3, persons_allowed: 4, photo: 'photo_url', description: 'Description', price: 100.5 }
      end

      it 'does not create a new room' do
        post '/api/v1/rooms', headers: headers, params: JSON.generate({ room: invalid_params })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['data']).to include 'errors'
        expect(Room.count).to eq 0
      end
    end

    context 'when the params are valid' do
      before { post '/api/v1/rooms', params: JSON.generate({ room: attributes_for(:room) }), headers: }

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
      delete api_v1_room_path(@room.id), headers:
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
