require 'rails_helper'

RSpec.describe 'Logouts', type: :request do
  describe 'DELETE /api/v1/logout' do
    let(:response_body) { JSON.parse(response.body)['data'] }
    let(:user) { create(:user) }
    context "when there's an active session" do
      it 'logouts the user' do
        delete '/api/v1/logout', headers: generate_jwt_token_for(user)

        expect(response).to have_http_status(:ok)
        expect(response_body['message']).to match(/logged out successfully/i)
      end
    end

    context "when there's no active session" do
      it 'responds with errors' do
        delete '/api/v1/logout'

        expect(response).to have_http_status(:unauthorized)
        expect(response_body['message']).to match(/couldn't find an active session/i)
      end
    end
  end
end
