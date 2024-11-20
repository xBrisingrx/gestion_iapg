class CreateInstructors < ActiveRecord::Migration[8.0]
  def change
    create_table :instructors do |t|
      t.references :person, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :theoretical, default: false
      t.boolean :practical, default: false
      t.string :code, limit:3
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :instructors, :person_id, unique: true
  end
end
