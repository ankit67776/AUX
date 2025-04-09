class RenameTargetUrlColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :ad_units, :targetUrl, :target_url
  end
end
