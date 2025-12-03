class AddDurationToCourseType < ActiveRecord::Migration[8.0]
  def change
    add_column :course_types, :duration, :integer, default: 2
  end
end
