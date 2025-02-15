class CreatePublisherSites < ActiveRecord::Migration[8.0]
  def change
    create_table :publisher_sites do |t|
      t.string :name
      t.string :url
      t.references :publisher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
