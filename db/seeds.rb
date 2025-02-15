# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create Users
user1 = User.create!(name: "Alice", email: "alice@example.com", role: "advertiser")
user2 = User.create!(name: "Bob", email: "bob@example.com", role: "publisher")

# Create Advertiser
advertiser = Advertiser.create!(name: "XYZ Ads", contact_email: "contact@xyz.com")

# Create Publisher
publisher = Publisher.create!(name: "ABC Media", contact_email: "publisher@abc.com")

# Create AdUnit
ad_unit = AdUnit.create!(name: "Banner Ad", ad_type: "banner", price: 10.5, advertiser: advertiser)

# Create Publisher Site
site = PublisherSite.create!(name: "Tech Blog", url: "https://techblog.com", publisher: publisher)

# Create AdImplementation
ad_implementation = AdImplementation.create!(ad_unit: ad_unit, publisher_site: site, position: "top")

# Create AdPerformance
AdPerformance.create!(ad_implementation: ad_implementation, impressions: 1000, clicks: 50, revenue: 25.0, date: Date.today)
