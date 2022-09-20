require 'rails_helper'

RSpec.describe 'Logins', type: :request do
  describe 'POST /api/v1/login' do
    let(:response_body) { JSON.parse(response.body) }
    let(:user) { create(:user, email: 'test@test.com', password: 'password') }

    context 'sending valid credentials' do
      it 'logins the user succesfully' do
        post '/api/v1/login',
             params: {
               user: {
                 login: user.username,
                 password: 'password'
               }
             }

        expect(response).to have_http_status(:ok)
        expect(response_body['data']['message']).to match(/successfully/i)
        expect(response_body['data']['user']['email']).to eq user.email
        expect(response.headers).to include('Authorization')
      end
    end

    context 'sending invalid credentials' do
      it 'responds with errors' do
        post '/api/v1/login',
             params: {
               user: {
                 login: 'otherusername',
                 password: 'password'
               }
             }
        expect(response).to have_http_status(401)
        expect(response_body['error']).to match(/invalid login or password/i)
        expect(response.headers).not_to include('Authorization')
      end
    end
  end
end
