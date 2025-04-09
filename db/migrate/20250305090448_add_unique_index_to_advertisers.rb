class AddUniqueIndexToAdvertisers < ActiveRecord::Migration[8.0]
  def change
    remove_index :advertisers, :user_id if index_exists?(:advertisers, :user_id)
    add_index :advertisers, :user_id, unique: true
  end
end
