require 'swagger_helper'
# rubocop:disable Metrics/BlockLength

RSpec.describe 'api/v1/rooms', type: :request do
  path '/api/v1/rooms' do
    get('list rooms') do
      tags 'Rooms'
      description 'List all rooms'
      produces 'application/json'
      security [bearer_auth: []]

      response(404, 'No rooms') do
        let(:user) { create(:user) }
        let(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, user)['Authorization'] }

        example 'application/json', :no_rooms, {
          message: 'No rooms found'
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
      response(200, 'Successful') do
        let(:user) { create(:user) }
        let(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, user)['Authorization'] }
        before { create_list(:room, 2) }

        example 'application/json', :successful, {
          code: 200,
          data: [
            {
              id: '1',
              type: 'room',
              attributes: {
                id: 1,
                name: 'Room 1',
                stars: 3,
                persons_allowed: 2,
                photo: 'photo_url',
                description: 'description',
                price: 340.7
              },
              relationships: {
                reservations: {
                  data: [
                    {
                      id: '4',
                      type: 'reservation'
                    }
                  ]
                },
                users: {
                  data: [
                    {
                      id: '1',
                      type: 'user'
                    }
                  ]
                }
              }
            }
          ]
        }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
