class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Flash
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_token

  respond_to :json

  private

  def invalid_token
    render json: { error: "Invalid or missing token" }, status: :unauthorized
  end
end
