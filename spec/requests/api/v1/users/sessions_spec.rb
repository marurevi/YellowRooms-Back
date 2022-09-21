require 'swagger_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'api/v1/users/sessions', type: :request do
  path '/api/v1/login' do
    post('create session') do
      tags 'Authentication'
      description 'Authenticates an user and returns a jwt token'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              login: { type: :string },
              password: { type: :string }
            },
            required: %w[login password]
          }
        }
      }

      response(200, 'successful') do
        let(:user) { create(:user, password: 'password') }
        let(:params) { { user: { login: user.username, password: user.password } } }

        example 'application/json', :successfull_login, {
          code: 200,
          data: {
            user: {
              id: 1,
              username: 'string',
              email: 'user@example.com'
            },
            message: 'Logged in successfully.'
          }
        }
        run_test!
      end

      response(401, 'Invalid credentials') do
        let(:params) { { user: { login: 'otherusername', password: 'password' } } }

        example 'application/json', :invalid_credentials, {
          error: 'Invalid Login or password.'
        }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
