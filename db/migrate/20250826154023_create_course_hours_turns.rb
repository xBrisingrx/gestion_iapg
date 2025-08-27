class CreateCourseHoursTurns < ActiveRecord::Migration[8.0]
  def change
    create_table :course_hours_turns do |t|
      t.references :course_type_unit, null: false, foreign_key: true
      t.time :hour

      t.timestamps
    end
  end
end
