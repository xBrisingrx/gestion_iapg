class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :cuil, null: false, limit: 20
      t.string :last_name, null: false, limit: 50
      t.string :name, null: false, limit: 50
      t.date :birthdate, null: false
      t.string :phone, limit: 50, null: false
      t.string :celphone, limit: 50, null: false
      t.string :email, null: false, limit: 50
      t.string :direction, limit: 100, null: false
      t.string :code, limit: 6
      t.references :province, foreign_key: true
      t.references :city, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :people, :cuil, unique: true
  end
end
