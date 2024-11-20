class CreateUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :units do |t|
      t.string :name, null: false, limit: 50
      t.string :description
      t.string :fleet, null: false, limit: 20
      t.string :methodology, null: false, limit: 20
      t.string :category, null: false, limit: 20
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
