class AddCredentialYearsToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :credential_years, :integer
  end
end
