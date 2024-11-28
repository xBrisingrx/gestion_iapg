class CreateTurns < ActiveRecord::Migration[8.0]
  def change
    create_table :turns do |t|
      t.references :course, null: false, foreign_key: true
      t.references :person, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.references :course_unit, null: false, foreign_key: true
      t.date :date
      t.time :hour
      t.boolean :available
      t.integer :list
      t.integer :status

      t.timestamps
    end
  end
end
