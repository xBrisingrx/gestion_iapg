class CreateCities < ActiveRecord::Migration[8.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.references :province, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
    add_index :cities, [ :name, :province_id ], unique: true
  end
end
