class AddCodeToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :code, :string, limit: 20
  end
end
