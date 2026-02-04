class CreatePriceCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :price_courses do |t|
      t.integer :price, null: false, default: 0
      t.references :course_type, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
