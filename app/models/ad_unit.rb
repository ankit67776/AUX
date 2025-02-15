class AdUnit < ApplicationRecord
  belongs_to :advertiser
  has_many :ad_implementations, dependent: :destroy
end
