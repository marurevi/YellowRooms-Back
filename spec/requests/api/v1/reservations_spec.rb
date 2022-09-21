require 'swagger_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'api/v1/reservations', type: :request do
  path '/api/v1/reservations' do
    let(:user) { create(:user) }
    let(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, user)['Authorization'] }

    get('list reservations') do
      tags 'Reservations'
      description 'List all reservations'
      produces 'application/json'
      security [bearer_auth: []]

      response(200, 'successful') do
        before { create_list(:reservation, 2) }

        example 'application/json', :successful, {
          code: 200,
          data: [
            {
              id: '1',
              type: 'reservation',
              attributes: {
                id: 1,
                user_id: 1,
                room_id: 1,
                start_date: '2022-09-21',
                end_date: '2022-09-23',
                city: 'Medellin'
              },
              relationships: {
                user: {
                  data: {
                    id: '1',
                    type: 'user'
                  }
                },
                room: {
                  data: {
                    id: '1',
                    type: 'room'
                  }
                }
              }
            }
          ]
        }

        run_test!
      end

      response(401, 'Unauthorized user') do
        let(:Authorization) { 'invalid_token' }
        example 'application/json', :unauthorized, {
          error: 'You need to sign in or sign up before continuing.'
        }
        run_test!
      end

      response(404, 'No reservations') do
        example 'application/json', :no_reservations, { error: "Couldn't find Reservation" }

        run_test!
      end
    end

    post('create reservation') do
      let(:room) { create(:room) }

      tags 'Reservations'
      description 'Create a reservation'
      consumes 'application/json'
      security [bearer_auth: []]

      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          room_id: { type: :integer },
          start_date: { type: :date, example: Date.today },
          end_date: { type: :date, example: Date.tomorrow },
          city: { type: :string }
        },
        required: %w[user_id room_id start_date end_date city]
      }

      response(201, 'successful') do
        let(:reservation) { attributes_for(:reservation, user_id: user.id, room_id: room.id) }

        example 'application/json', :successful, {
          code: 201,
          data: {
            id: 2,
            user_id: 1,
            room_id: 1,
            start_date: '2022-09-21',
            end_date: '2022-09-22',
            city: 'string'
          }
        }

        run_test!
      end

      response(401, 'Unauthorized user') do
        let(:reservation) { nil }
        let(:Authorization) { 'invalid_token' }
        example 'application/json', :unauthorized, {
          error: 'You need to sign in or sign up before continuing.'
        }
        run_test!
      end

      response(422, 'Invalid params') do
        let(:reservation) do
          attributes_for(:reservation, user_id: user.id, room_id: room.id, start_date: Date.yesterday)
        end
        example 'application/json', :invalid_date, {
          code: 422,
          data: {
            errors: 'Start date must be greater than or equal to 2022-09-21 and Room is not available'
          }
        }

        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
