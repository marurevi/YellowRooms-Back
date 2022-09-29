class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  before_action :configure_sign_up_params, only: [:create]

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        code: 201,
        data: {
          message: 'Signed up succesfully!',
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }, status: :created
    else
      render json: {
        data: {
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email password])
  end
end
