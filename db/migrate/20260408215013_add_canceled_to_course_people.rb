class AddCanceledToCoursePeople < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :canceled, :boolean, default: false
  end
end
