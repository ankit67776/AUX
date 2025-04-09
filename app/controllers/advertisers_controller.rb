class AdvertisersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  # signup advertiser
  def create
    user = current_user

    # check if the user has an advertiser
    if user.advertiser.present?
      render json: { message: "Advertiser already exists for this user", advertiser: user.advertiser }, status: :unprocessable_entity
      return
    end

    # if no advertiser exists create a new one
    advertiser = user.build_advertiser(advertiser_params)

    if advertiser.save
      render json: { message: "Advertiser created successfully" }, status: :created
    else
      render json: { errors: advertiser.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def advertiser_params
    params.require(:advertiser).permit(:company_name, :website)
  end
end
