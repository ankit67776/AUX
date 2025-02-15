class Advertiser < ApplicationRecord
  has_many :ad_units, dependent: :destroy
end
