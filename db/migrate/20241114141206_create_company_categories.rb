class CreateCompanyCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :company_categories do |t|
      t.string :name, null: false, limit: 50
      t.string :description
      t.integer :quota, null: false
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :company_categories, :name, unique: true
  end
end
