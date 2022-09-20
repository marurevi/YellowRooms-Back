class Api::V1::Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
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

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])
  end
end
