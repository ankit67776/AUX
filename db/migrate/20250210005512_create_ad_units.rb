class CreateAdUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_units do |t|
      t.string :name
      t.string :ad_type
      t.decimal :price
      t.references :advertiser, null: false, foreign_key: true

      t.timestamps
    end
  end
end
