class CompanyCanBeNullToCoursePeople < ActiveRecord::Migration[8.0]
  def change
    change_column_null :course_people, :company_id, true
  end
end
