class AddExpirationDateToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :expiration_date, :date
  end
end
