class ChangeRequiredToInstructorIdonCourseUnit < ActiveRecord::Migration[8.0]
  def change
    # change_column :course_units, :instructor_id, null: true
    remove_reference :course_units, :instructor, foreign_key: true, index: false
    add_reference :course_units, :instructor, foreign_key: true, null: true
  end
end
