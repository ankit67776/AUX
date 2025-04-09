class GoogleAdsController < ApplicationController
  before_action :authenticate_user!

  def index
    google_ads_service = GoogleAdsService.new

    # Get all managed client accounts
    @accounts = google_ads_service.list_managed_accounts

    # Fetch campaigns for each client account
    @campaigns = {}
    @accounts.each do |account|
      client_id = account[:id].to_s
      @campaigns[client_id] = google_ads_service.get_campaigns(client_id)
    end

    render json: { accounts: @accounts, campaigns: @campaigns }
  end
end
