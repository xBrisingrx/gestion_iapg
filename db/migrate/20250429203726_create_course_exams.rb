class CreateCourseExams < ActiveRecord::Migration[8.0]
  def change
    create_table :course_exams do |t|
      t.references :course, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true
      t.boolean :retake
      t.integer :num_retake
      t.integer :fleet
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
