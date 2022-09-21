require 'swagger_helper'
# rubocop:disable Metrics/BlockLength

RSpec.describe 'api/v1/rooms', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { Devise::JWT::TestHelpers.auth_headers({}, user)['Authorization'] }

  path '/api/v1/rooms' do
    get('list rooms') do
      tags 'Rooms'
      description 'List all rooms'
      produces 'application/json'
      security [bearer_auth: []]

      response(404, 'No rooms') do
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

    post('create room') do
      tags 'Rooms'
      description 'Create a room'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          stars: { type: :integer },
          persons_allowed: { type: :integer },
          photo: { type: :string, example: 'http://photo_url' },
          description: { type: :string },
          price: { type: :number }
        },
        required: %w[name stars persons_allowed photo description price]
      }

      response(201, 'Successful') do
        let(:room) { attributes_for(:room) }
        example 'application/json', :successful, {
          code: 201,
          data: {
            id: 6,
            name: 'string',
            stars: 0,
            persons_allowed: 0,
            photo: 'http://photo_url',
            description: 'string',
            price: 0
          }
        }
        run_test!
      end

      response(422, 'Invalid params') do
        let(:room) { attributes_for(:room, photo: 'photo') }
        example 'application/json', :invalid_photo, {
          code: 422,
          data: {
            errors: 'Photo is invalid'
          }
        }
        run_test!
      end

      response(401, 'Unauthorized user') do
        let(:room) { attributes_for(:room) }
        let(:Authorization) { 'invalid_token' }
        example 'application/json', :unauthorized, {
          error: 'You need to sign in or sign up before continuing.'
        }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
