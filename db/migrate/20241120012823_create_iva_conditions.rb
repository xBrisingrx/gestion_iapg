class CreateIvaConditions < ActiveRecord::Migration[8.0]
  def change
    create_table :iva_conditions do |t|
      t.string :name, null: false, limit: 50
      t.string :description
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :iva_conditions, :name, unique: true
  end
end
