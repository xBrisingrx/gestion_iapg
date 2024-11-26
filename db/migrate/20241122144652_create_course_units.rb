class CreateCourseUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :course_units do |t|
      t.references :course, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.references :instructor, null: false, foreign_key: true
      t.string :shift
      t.integer :day
      t.time :start_hour
      t.time :end_hour
      t.date :date
      t.integer :shift_time
      t.integer :list
      t.boolean :complete, default: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
