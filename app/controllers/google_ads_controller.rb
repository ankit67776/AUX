class GoogleAdsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Cache key unique per user
    cache_key = "google_ads_data_user_#{@current_user.id}"

    full_data = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      google_ads_service = GoogleAdsService.new
      accounts = google_ads_service.list_managed_accounts
      total_metrics = google_ads_service.get_total_metrics # Optional: add to response if needed

      accounts.map do |account|
        client_id = account[:id].to_s

        campaigns = google_ads_service.get_campaigns(client_id)
        ads = google_ads_service.get_display_ads(client_id)

        # Resolve asset URLs
        ads.each do |ad|
          ad[:marketing_images] = ad[:marketing_images].map do |asset|
            google_ads_service.get_asset_url(client_id, asset)
          end.compact

          ad[:square_marketing_images] = ad[:square_marketing_images].map do |asset|
            google_ads_service.get_asset_url(client_id, asset)
          end.compact

          ad[:logo_images] = ad[:logo_images].map do |asset|
            google_ads_service.get_asset_url(client_id, asset)
          end.compact
        end

        {
          id: account[:id],
          name: account[:name],
          display_ads: ads
        }
      end
    end

    render json: { accounts: full_data }
  end

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    rescue JWT::DecodeError => e
      render json: { error: "Unauthorized: #{e.message}" }, status: :unauthorized
    end
  end
end
