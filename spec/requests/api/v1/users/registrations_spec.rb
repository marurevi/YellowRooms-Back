require 'swagger_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'api/v1/users/registrations', type: :request do
  path '/api/v1/register' do
    post('create account') do
      tags 'Authentication'
      description 'creates an account'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: 'email' },
              username: { type: :string },
              password: { type: :string }
            },
            required: %w[email username password]
          }
        }
      }

      response(201, 'Account created') do
        let(:params) { { user: attributes_for(:user) } }

        example 'application/json', :successfull_request, {
          code: 201,
          data: {
            message: 'Signed up succesfully!',
            user: {
              id: 1,
              username: 'string',
              email: 'user@example.com'
            }
          }
        }

        run_test!
      end

      response(422, 'Invalid params') do
        let(:params) { { user: { username: '', email: 'test@test.com', password: 'password' } } }

        example 'application/json', :blank_username, {
          data: {
            message: "User couldn't be created successfully. Username can't be blank, and Username only allows letters"
          }
        }

        example 'application/json', :blank_email, {
          data: {
            message: "User couldn't be created successfully. Email can't be blank"
          }
        }

        example 'application/json', :username_taken, {
          data: {
            message: "User couldn't be created successfully. Username has already been taken"
          }
        }

        example 'application/json', :email_taken, {
          data: {
            message: "User couldn't be created successfully. Email has already been taken"
          }
        }

        example 'application/json', :invalid_username, {
          data: {
            message: "User couldn't be created successfully. Username only allows letters"
          }
        }

        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
