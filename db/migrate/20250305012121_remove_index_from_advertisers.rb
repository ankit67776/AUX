class RemoveIndexFromAdvertisers < ActiveRecord::Migration[7.0]
  def change
    remove_index :advertisers, :user_id if index_exists?(:advertisers, :user_id)
  end
end
