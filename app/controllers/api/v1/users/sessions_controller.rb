class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      code: 200,
      data: {
        user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
        message: 'Logged in successfully.'
      }
    }, status: :ok
  end
end
