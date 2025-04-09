class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one :advertiser, dependent: :restrict_with_error
  validates :name, :email, presence: true
  validates :email, uniqueness: true

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.name = auth.info.name
      user.google_uid = auth.uid
      user.google_token = auth.credentials.token
      user.google_refresh_token = auth.credentials.refresh_token
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
