class AdUnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_advertiser_role, only: [ :create ]
  skip_before_action :verify_authenticity_token


  def index
    if current_user.advertiser
      ads = current_user.advertiser.ad_units.includes(:advertiser)

      ads_with_media = ads.map do |ad|
        ad.as_json(only: [ :id, :name, :target_url ]).merge(
          media_url: ad.media.attached? ? url_for(ad.media) : nil  # Handle Active Storage
        )
      end

      render json: ads_with_media, status: :ok
    else
      render json: { error: "Only advertisers can view their ads" }, status: :forbidden
    end
  end



  def create
    Rails.logger.info "Received request to create adunit: #{params.inspect}"
    Rails.logger.info "Current User: #{current_user.inspect}"

    if current_user.advertiser.nil?
      Rails.logger.error "User is not an advertiser"
      return render json: { error: "Only advertiser can post ads" }, status: :forbidden
    end


    ad_unit = current_user.advertiser.ad_units.create(ad_unit_params)

    if ad_unit.persisted?
      Rails.logger.info "Ad created Successfully: #{ad_unit.inspect}"
      render json: { message: "Ad created successfully" }, status: :created
    else
      Rails.logger.error "Failed to create adUnit: #{ad_unit.errors.full_messages}"
      render json: { errors: ad_unit.errors.full_messages }, status: :unprocessable_entity
    end
  end



  private
  def ad_unit_params
    params.require(:ad_unit).permit(:name, :media, :target_url, :size).tap do |whitelisted|
      Rails.logger.info "Permitted ad_units_params: #{whitelisted.inspect}"
    end
  end

  def check_advertiser_role
    return if current_user.advertiser
    Rails.logger.error "User #{current_user.id} is not an advertiser"
    render json: { error: "Only advertiser can post ads" }, status: :forbidden
  end
end
