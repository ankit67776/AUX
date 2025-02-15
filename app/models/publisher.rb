class Publisher < ApplicationRecord
  has_many :publisher_sites, dependent: :destroy
end
