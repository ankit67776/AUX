class CreateAdPerformances < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_performances do |t|
      t.references :ad_implementation, null: false, foreign_key: true
      t.integer :impressions
      t.integer :clicks
      t.decimal :revenue
      t.date :date

      t.timestamps
    end
  end
end
