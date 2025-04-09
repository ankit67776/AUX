class Advertiser < ApplicationRecord
  belongs_to :user
  has_many :ad_units, dependent: :destroy

  validates :company_name, presence: true
  validates :user_id, uniqueness: true
  validates :website, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }
end
