class AddIsFreeToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :is_free, :boolean, default: false
  end
end
