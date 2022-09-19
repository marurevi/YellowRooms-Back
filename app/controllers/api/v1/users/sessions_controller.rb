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

  def respond_to_on_destroy
    if current_user
      render json: {
        code: 200,
        data: {
          message: 'logged out successfully'
        }
      }, status: :ok
    else
      render json: {
        code: 401,
        data: {
          message: "Couldn't find an active session."
        }
      }, status: :unauthorized
    end
  end
end
