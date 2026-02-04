class AddPaticularTypeToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    change_column_null :course_people, :manager_id, true
    change_column_null :course_people, :operator_id, true
    change_column_null :course_people, :fleet_category_id, true
    change_column_null :course_people, :inscription_motive_id, true
  end
end
