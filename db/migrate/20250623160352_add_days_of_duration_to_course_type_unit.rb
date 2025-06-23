class AddDaysOfDurationToCourseTypeUnit < ActiveRecord::Migration[8.0]
  def change
    add_column :course_type_units, :days_of_duration, :integer, default: 1
  end
end
