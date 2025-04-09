class AddSizeToAdUnits < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_units, :size, :string
  end
end
