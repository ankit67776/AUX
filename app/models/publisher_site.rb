class PublisherSite < ApplicationRecord
  belongs_to :publisher
  has_many :ad_implementations, dependent: :destroy
end
