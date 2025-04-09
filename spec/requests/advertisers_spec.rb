require 'rails_helper'

RSpec.describe AdUnitsController, type: :controller do
  include FactoryBot::Syntax::Methods
  let(:user) { create(:user) } # A normal user without an advertiser role
  let(:advertiser) { create(:user, :advertiser) } # A user with an advertiser role

  describe "POST #create" do
    context "when user is not an advertiser" do
      before do
        sign_in user # Simulate login
        post :create, params: { ad_unit: { title: "Test Ad", adFormat: "banner", media: "image.png", targetUrl: "http://example.com" } }
      end

      it "returns a forbidden status" do
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)).to eq({ "error" => "Only advertiser can post ads" })
      end
    end

    context "when user is an advertiser" do
      before do
        sign_in advertiser # Simulate login
      end

      it "creates an ad successfully" do
        expect {
          post :create, params: { ad_unit: { title: "New Ad", adFormat: "video", media: "video.mp4", targetUrl: "http://example.com" } }
        }.to change(AdUnit, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq("Ad created successfully")
      end
    end

    context "when advertiser record is nil" do
      before do
        allow_any_instance_of(User).to receive(:advertiser).and_return(nil)
        sign_in advertiser
        post :create, params: { ad_unit: { title: "Invalid Ad", adFormat: "popup", media: "ad.png", targetUrl: "http://example.com" } }
      end

      it "returns an error instead of crashing" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Advertiser profile is missing" })
      end
    end
  end
end
