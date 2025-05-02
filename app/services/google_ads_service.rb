require "google/ads/google_ads"
require "net/http"
require "uri"
require "json"
require "googleauth"

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

  def get_total_metrics
    url = URI("https://googleads.googleapis.com/v17/customers/9176619925/googleAds:search")

    # define the request body
    query = {
      query: "SELECT metrics.impressions, metrics.clicks, metrics.ctr FROM customer WHERE segments.date DURING LAST_30_DAYS"
    }
    # set the headers
    headers = {

      "Content-Type" => "application/json"


    }

    response = Net::HTTP.post(url, query.to_json, headers)

    if response.is_a?(Net::HTTPSuccess)
      # Parse the JSON response
      result = JSON.parse(response.body)
      # Process the result here
      total_impressions = 0
      total_clicks = 0
      total_ctr = 0.0

      result["results"].each do |row|
        total_impressions += row["metrics"]["impressions"].to_i
        total_clicks += row["metrics"]["clicks"].to_i
        total_ctr += row["metrics"]["ctr"].to_f
      end

      average_ctr = result["results"].size > 0 ? total_ctr / result["results"].size : 0
      {
        impressions: total_impressions,
        clicks: total_clicks,
        avg_ctr: average_ctr
      }
    else
      # Handle error response
      puts "Error: #{response.body}"
    end
  end


  def get_ad_groups(customer_id)
    query = <<~GAQL
      SELECT
        ad_group.id,
        ad_group.name,
        ad_group.status,
        ad_group.cpc_bid_micros,
        metrics.impressions,
        metrics.clicks,
        metrics.ctr,
        metrics.average_cpc,
        metrics.cost_micros
      FROM ad_group
      WHERE segments.date DURING LAST_30_DAYS
    GAQL

    response = @client.service.google_ads.search(
      customer_id: customer_id,
      query: query
    )

    response.map do |row|
      {
        id: row.ad_group.id,
        name: row.ad_group.name,
        status: row.ad_group.status,
        bid: row.ad_group.cpc_bid_micros.to_f / 1_000_000,
        impressions: row.metrics.impressions,
        clicks: row.metrics.clicks,
        ctr: row.metrics.ctr,
        avg_cpc: row.metrics.average_cpc,
        cost: row.metrics.cost_micros.to_f / 1_000_000
      }
    end
  end

  def get_account_performance(customer_id)
    query = <<~GAQL
      SELECT
    metrics.impressions,

  FROM customer
    GAQL

    response = @client.service.google_ads.search(
      customer_id: customer_id,
      query: query
    )

    response.each_with_object({ daily_metrics: [], summary: {} }) do |row, result|
      daily_metric = {
        date: row.segments.date,
        impressions: row.metrics.impressions
        # clicks: row.metrics.clicks,
        # ctr: row.metrics.ctr,
        # cost: row.metrics.cost_micros.to_f / 1_000_000,
        # conversions: row.metrics.conversions
      }
      result[:daily_metrics] << daily_metric
    end
  end

  def get_audience_insights(customer_id)
    query = <<~GAQL
      SELECT
        audience.user_interest.name,
        metrics.impressions,
        metrics.clicks,
        metrics.conversions,
        metrics.cost_micros
      FROM user_interest
      WHERE segments.date DURING LAST_30_DAYS
      ORDER BY metrics.impressions DESC
      LIMIT 10
    GAQL

    response = @client.service.google_ads.search(
      customer_id: customer_id,
      query: query
    )

    response.map do |row|
      {
        interest: row.audience.user_interest.name,
        impressions: row.metrics.impressions,
        clicks: row.metrics.clicks,
        conversions: row.metrics.conversions,
        cost: row.metrics.cost_micros.to_f / 1_000_000
      }
    end
  end

  def get_campaigns(customer_id)
    query = <<~SQL
      SELECT campaign.id, campaign.name, campaign.status FROM campaign
    SQL

    response = @client.service.google_ads.search(
      customer_id: customer_id,
      query: query
    )

    campaigns = response.map do |row|
      { id: row.campaign.id, name: row.campaign.name, status: row.campaign.status }
    end

    puts "Campaigns for Customer #{customer_id}: #{campaigns.inspect}"
    campaigns
  end

  def list_managed_accounts
    query = <<~SQL
      SELECT customer_client.id, customer_client.descriptive_name
      FROM customer_client
    SQL

    response = @client.service.google_ads.search(
      customer_id: ENV["GOOGLE_ADS_LOGIN_CUSTOMER_ID"],
      query: query
    )

    accounts = []
    response.each do |row|
      accounts << { id: row.customer_client.id, name: row.customer_client.descriptive_name }
    end

    accounts
  end

  def get_display_ads(customer_id)
    client = @client

    query = <<~GAQL
      SELECT
        ad_group_ad.ad.id,
        ad_group_ad.ad.name,
        ad_group_ad.ad.final_urls,
        ad_group_ad.ad.responsive_display_ad.headlines,
        ad_group_ad.ad.responsive_display_ad.descriptions,
        ad_group_ad.ad.responsive_display_ad.marketing_images,
        ad_group_ad.ad.responsive_display_ad.square_marketing_images,
        ad_group_ad.ad.responsive_display_ad.logo_images
      FROM ad_group_ad
      WHERE ad_group_ad.ad.type = 'RESPONSIVE_DISPLAY_AD'
    GAQL

    response = client.service.google_ads.search(customer_id: customer_id, query: query)

    ads = []

    response.each do |row|
      ad = row.ad_group_ad.ad
      responsive = ad.responsive_display_ad

      ads << {
        id: ad.id,
        name: ad.name,
        final_urls: ad.final_urls.to_a,
        headlines: responsive.headlines.map(&:text),
        descriptions: responsive.descriptions.map(&:text),
        marketing_images: responsive.marketing_images.map(&:asset),
        square_marketing_images: responsive.square_marketing_images.map(&:asset),
        logo_images: responsive.logo_images.map(&:asset)
      }
    end

    ads
  end

  def get_asset_url(customer_id, asset_resource_name)
    query = <<~GAQL
      SELECT asset.resource_name, asset.name, asset.type, asset.image_asset.full_size.url
      FROM asset
      WHERE asset.resource_name = '#{asset_resource_name}'
    GAQL

    response = @client.service.google_ads.search(
      customer_id: customer_id,
      query: query
    )

    asset = response.first&.asset

    {
      name: asset.name,
      type: asset.type,
      url: asset.image_asset&.full_size&.url
    }
  end
end
