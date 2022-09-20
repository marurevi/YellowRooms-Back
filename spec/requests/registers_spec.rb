require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'POST /api/v1/register' do
    let(:response_body) { JSON.parse(response.body)['data'] }

    context 'sending valid parameters' do
      it 'creates a new user' do
        post '/api/v1/register',
             params: {
               user: {
                 username: 'test',
                 email: 'test@test.com',
                 password: 'password'
               }
             }

        expect(response).to have_http_status(:created)
        expect(response_body['message']).to match(/succesfully/i)
        expect(response_body['user']['email']).to eq 'test@test.com'
      end
    end

    context 'sending invalid parameters' do
      it 'Does not create the user and responde with errors' do
        post '/api/v1/register',
             params: {
               user: {
                 username: '',
                 email: 'test@test.com',
                 password: 'password'
               }
             }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body['message']).to match(/user couldn't be created successfully/i)
      end
    end
  end
end
