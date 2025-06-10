class AddApprovedtoCoursePerson < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :approved, :boolean, default: false
  end
end
