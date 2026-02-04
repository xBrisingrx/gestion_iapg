class AddYearsOfDurationToCourse < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :years_of_duration, :integer
  end
end
