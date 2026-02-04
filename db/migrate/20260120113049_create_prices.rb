class CreatePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :prices do |t|
      t.integer :price, null: false
      t.references :unit, null: false, foreign_key: true
      t.integer :client_type
      t.references :sectional, null: true, foreign_key: true
      t.references :company, null: true, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
