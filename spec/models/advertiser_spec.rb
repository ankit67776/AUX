require 'rails_helper'

RSpec.describe Advertiser, type: :model do
  let(:user) { User.create(name: "John Doe", email: "john@test.com", password: "123456") }

  it "is valid with valid attributes" do
    advertiser = user.build_advertiser(company_name: "AdCorp", website: "https://adcorp.com")
    expect(advertiser).to be_valid
  end

  it "is not valid without a company_name" do
    advertiser = user.build_advertiser(company_name: nil, website: "https://adcorp.com")
    expect(advertiser).not_to be_valid
  end

  it "is not valid without a website" do
    advertiser = user.build_advertiser(company_name: "AdCorp", website: nil)
    expect(advertiser).not_to be_valid
  end


  it "does not allow a user to have more than one advertiser" do
    user.create_advertiser!(company_name: "AdCorp", website: "https://adcorp.com")

    # Try to create another advertiser for the same user useing Advertiser.new because was getting error using "build_advertiser"
    second_advertiser = Advertiser.new(user: user, company_name: "AnotherCorp", website: "https://adcorp.com")

    expect(second_advertiser).not_to be_valid
    expect(second_advertiser.errors[:user_id]).to include("has already been taken")
  end
end
