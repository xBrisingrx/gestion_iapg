class CreateHeadquarters < ActiveRecord::Migration[8.0]
  def change
    create_table :headquarters do |t|
      t.string :name, null: false, limit: 100
      t.string :description
      t.string :location, limit: 100
      t.references :sectional, null: false, foreign_key: true
      t.references :province, foreign_key: true
      t.references :city, foreign_key: true
      t.boolean :can_make_psychometric, default: false
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :headquarters, :name, unique: true
  end
end
