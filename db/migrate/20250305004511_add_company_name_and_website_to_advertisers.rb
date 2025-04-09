class AddCompanyNameAndWebsiteToAdvertisers < ActiveRecord::Migration[8.0]
  def change
    add_column :advertisers, :company_name, :string
    add_column :advertisers, :website, :string
  end
end
