require "google/ads/google_ads"

class GoogleAdsService
  def initialize
    @client = Google::Ads::GoogleAds::GoogleAdsClient.new do |config|
      config.developer_token = ENV["GOOGLE_ADS_DEVELOPER_TOKEN"]
      config.client_id = ENV["GOOGLE_OAUTH_CLIENT_ID"]
      config.client_secret = ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
      config.refresh_token = ENV["GOOGLE_OAUTH_REFRESH_TOKEN"]
      config.login_customer_id = ENV["GOOGLE_ADS_LOGIN_CUSTOMER_ID"] # Manager Account
    end
  end

  # Fetch campaigns from a specific client account
  def get_campaigns(customer_id)
    query = <<~SQL
      SELECT campaign.id, campaign.name, campaign.status FROM campaign
    SQL

    response = @client.service.google_ads.search(
      customer_id: customer_id,  # Fetch campaigns from a client account
      query: query
    )

    campaigns = response.map { |row| { id: row.campaign.id, name: row.campaign.name, status: row.campaign.status } }
    puts "Campaigns for Customer #{customer_id}: #{campaigns.inspect}"

    campaigns
  end

  # List managed accounts under MCC (Manager Account)
  def list_managed_accounts
    query = <<~SQL
      SELECT customer_client.id, customer_client.descriptive_name
      FROM customer_client
    SQL

    response = @client.service.google_ads.search(
      customer_id: ENV["GOOGLE_ADS_LOGIN_CUSTOMER_ID"], # Manager Account ID
      query: query
    )

    accounts = []
    response.each do |row|
      accounts << { id: row.customer_client.id, name: row.customer_client.descriptive_name }
    end

    accounts
  end
end
