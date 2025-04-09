class AddUserIdToAdvertisers < ActiveRecord::Migration[8.0]
  def change
    add_reference :advertisers, :user, null: false, foreign_key: true, unique: true
  end
end
