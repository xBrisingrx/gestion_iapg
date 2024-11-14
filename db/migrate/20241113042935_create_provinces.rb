class CreateProvinces < ActiveRecord::Migration[8.0]
  def change
    create_table :provinces do |t|
      t.string :name, null: false, limit: 20
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
