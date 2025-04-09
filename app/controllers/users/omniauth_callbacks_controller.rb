class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [ :google_oauth2 ]

  def passthru
    Rails.logger.debug ">>> Passthru called! Redirecting manually."
    redirect_to user_google_oauth2_omniauth_authorize_path
  end

  def google_oauth2
    Rails.logger.debug ">>> OmniAuth Auth Hash: #{request.env['omniauth.auth'].inspect}"

    auth = request.env["omniauth.auth"]

    if auth.blank?
      Rails.logger.debug ">>> AUTH HASH IS EMPTY! OmniAuth isn't working correctly."
      redirect_to new_user_registration_url, alert: "Google authentication failed"
      return
    end

    user = User.from_omniauth(auth)

    if user.persisted?
      Rails.logger.debug ">>> User found: #{user.inspect}"
      sign_in(user)

      # ✅ Manually redirect to Next.js frontend
      redirect_to "http://localhost:3001/advertiser/ads"
    else
      Rails.logger.debug ">>> User creation failed"
      redirect_to new_user_registration_url, alert: "Google authentication failed"
    end
  end
end
