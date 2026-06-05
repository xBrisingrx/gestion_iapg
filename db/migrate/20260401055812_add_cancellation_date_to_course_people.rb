class AddCancellationDateToCoursePeople < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :cancellation_date, :date
  end
end
