class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user
      token = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first

      render json: {
        message: "Logged in with Google!",
        token: token,
        user: {
          id: @user.id,
          name: @user.name,
          email: @user.email
        }
      }
    else
      redirect_to new_user_registration_url
    end
  end
end
