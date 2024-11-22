class CreateFleetCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :fleet_categories do |t|
      t.string :name, null: false, limit: 50
      t.string :description
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :fleet_categories, :name, unique: true
  end
end
