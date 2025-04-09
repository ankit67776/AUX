class AddFieldsToAdUnits < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_units, :media, :string
    add_column :ad_units, :targetUrl, :string
  end
end
