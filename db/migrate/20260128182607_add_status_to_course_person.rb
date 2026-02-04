class AddStatusToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :status, :string
  end
end
