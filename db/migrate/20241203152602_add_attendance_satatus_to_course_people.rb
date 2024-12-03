class AddAttendanceSatatusToCoursePeople < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :attendance_status, :integer
    add_column :course_people, :scoring, :integer
  end
end
