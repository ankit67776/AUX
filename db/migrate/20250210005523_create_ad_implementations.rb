class CreateAdImplementations < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_implementations do |t|
      t.references :ad_unit, null: false, foreign_key: true
      t.references :publisher_site, null: false, foreign_key: true
      t.string :position

      t.timestamps
    end
  end
end
