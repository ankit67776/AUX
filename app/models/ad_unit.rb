class AdUnit < ApplicationRecord
  belongs_to :advertiser
  has_many :ad_implementations, dependent: :destroy
  has_one_attached :media

  validates :name, :target_url, :size, presence: true
  validates :size, inclusion: { in: [ "728x90", "468x60", "120x600", "160x600", "300x600", "300x250" ] }
end
