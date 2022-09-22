require 'rails_helper'

RSpec.describe 'Reservations', type: :request do
  let(:user) { create(:user) }
  let(:headers) { generate_jwt_token_for(user) }

  describe 'GET /api/v1/reservations' do
    before { get api_v1_reservations_path, headers: }

    context 'when there are no reservations' do
      it 'returns a 404 status code' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Reservation/)
      end
    end
    context 'when there are reservations' do
      let(:user) { create(:user) }
      let(:headers) { generate_jwt_token_for(user) }
      before do
        @room1 = create(:room, name: 'Room 1')
        @room2 = create(:room, name: 'Room 2')
        @room3 = create(:room, name: 'Room 3')

        @r1 = create(:reservation, user:, room: @room1, start_date: Date.today,
                                   end_date: Date.today + 1.day)
        @r2 = create(:reservation, user:, room: @room2, start_date: Date.today,
                                   end_date: Date.today + 3.day)
        @r3 = create(:reservation, user:, room: @room3, start_date: Date.today,
                                   end_date: Date.today + 2.day)
        get api_v1_reservations_path, headers:
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all reservations' do
        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(3)
      end

      it 'returns the correct reservations' do
        data = JSON.parse(response.body)['data']
        expect(data.map { |r| r['id'].to_i }).to match_array([@r1.id, @r2.id, @r3.id])
      end
    end
  end

  describe 'POST /api/v1/reservations' do
    context 'when the params are invalid' do
      let(:invalid_params) do
        { reservation: { start_date: '', end_date: '', user_id: 1, room_id: 1 } }
      end
      it 'does not create a new reservation' do
        expect do
          post api_v1_reservations_path, params: JSON.generate(invalid_params), headers:
        end.to change(Reservation, :count).by(0)
      end
      it 'returns http unprocessable entity' do
        post api_v1_reservations_path, headers: headers, params: JSON.generate(invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    context 'when the params are valid' do
      before do
        @room = create(:room)
        post api_v1_reservations_path, headers:,
                                       params: JSON.generate({
                                                               reservation: attributes_for(
                                                                 :reservation,
                                                                 user_id: user.id,
                                                                 room_id: @room.id
                                                               )
                                                             })
      end
      it 'returns http created' do
        expect(response).to have_http_status(:created)
      end
      it 'creates a new reservation' do
        expect(Reservation.count).to eq(1)
      end

      it 'returns the correct reservation' do
        data = JSON.parse(response.body)['data']
        expect(data['user_id']).to eq(user.id)
        expect(data['room_id']).to eq(@room.id)
      end
    end
  end

  describe 'DELETE /api/v1/reservations/:id' do
    context 'when the reservation does not exist' do
      it 'returns http not found' do
        delete api_v1_reservation_path(1), headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the reservation exists' do
      before do
        @room = create(:room)
        @reservation = create(:reservation, user:, room: @room)
        delete api_v1_reservation_path(@reservation), headers:
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
      it 'deletes the reservation' do
        expect(Reservation.count).to eq(0)
      end
    end
  end
end
