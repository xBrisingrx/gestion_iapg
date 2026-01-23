class AddPrinceAndPayStatusToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :price, :integer, default: 0
    add_column :course_people, :pay_status, :integer, default: 0
  end
end
