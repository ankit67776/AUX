# app/controllers/api/auth_controller.rb
require "google-id-token"

class Api::AuthController < ApplicationController
  def google
    puts "Incoming ID token: #{params[:id_token]}"
    puts "ENV Client ID: #{ENV['GOOGLE_OAUTH_CLIENT_ID']}"

    validator = GoogleIDToken::Validator.new
    id_token = params[:id_token]

    begin
      payload = validator.check(id_token, ENV["GOOGLE_OAUTH_CLIENT_ID"])

      email = payload["email"]
      name = payload["name"]

      user = User.find_or_create_by(email: email) do |u|
        u.name = name
        u.password = Devise.friendly_token[0, 20]
        u.role = params[:role] || "advertiser"
      end

      jwt = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)

      render json: { user: user.as_json(only: [ :id, :email, :name, :role ]), token: jwt }
    rescue GoogleIDToken::ValidationError => e
      render json: { error: "Invalid ID token: #{e}" }, status: :unauthorized
    end
  end
end
