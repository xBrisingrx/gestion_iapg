class CreateCompanyManagers < ActiveRecord::Migration[8.0]
  def change
    create_table :company_managers do |t|
      t.references :company, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.string :email
      t.string :job
      t.boolean :notifications, default: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
