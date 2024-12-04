class AddRecuExamnToCoursePeople < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :make_up_1, :integer
    add_column :course_people, :date_make_up_1, :date
    add_column :course_people, :make_up_2, :integer
    add_column :course_people, :date_make_up_2, :date
  end
end
