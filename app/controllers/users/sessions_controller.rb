class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def google_auth
    auth = request.env["omniauth.auth"]

    advertiser = Advertiser.find_or_create_by(email: auth.info.email) do |a|
      a.name = auth.info.name
      a.google_uid = auth.uid
      a.google_token = auth.credentials.token
      a.google_refresh_token = auth.credentials.refresh_token
    end

    if advertiser.persisted?
      session[:advertiser_id] = advertiser.id

      render json: {
        message: "Google account connected!",
        user: advertiser.as_json(only: [ :id, :name, :email, :google_uid ]),
        token: auth.credentials.token
      }, status: :ok
    else
      render json: { error: "Google authentication failed" }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      token = request.env["warden-jwt_auth.token"] # Retrieve JWT if using JWT authentication

      render json: {
        message: "Logged in successfully",
        user: resource.as_json(only: [ :id, :name, :email, :role, :created_at, :updated_at, :admin ]),
        token: token
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { error: "No active session found" }, status: :unauthorized
    end
  end
end
