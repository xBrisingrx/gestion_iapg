class CreateCourseTypeUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :course_type_units do |t|
      t.references :course_type, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.integer :day, null: false
      t.time :start_hour
      t.time :end_hour
      t.boolean :is_by_turn
      t.string :shift
      t.integer :shift_time

      t.timestamps
    end
  end
end
