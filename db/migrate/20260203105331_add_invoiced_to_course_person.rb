class AddInvoicedToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    add_column :course_people, :invoiced, :boolean, default: false
  end
end
