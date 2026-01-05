class CreateSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :seats do |t|
      t.references :company, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.references :manager, foreign_key: { to_table: :people }, null: true
      t.references :operator, foreign_key: { to_table: :companies }, null: true
      t.references :inscription_motive, null: true, foreign_key: true
      t.references :fleet_category, null: true, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :status
      t.integer :seat_type, default: 0

      t.timestamps
    end
  end
end
