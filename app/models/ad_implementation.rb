class AdImplementation < ApplicationRecord
  belongs_to :ad_unit
  belongs_to :publisher_site
  has_many :ad_performances, dependent: :destroy
end
