class AddOmniauthToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :google_uid, :string
    add_column :users, :google_token, :string
    add_column :users, :google_refresh_token, :string
  end
end
