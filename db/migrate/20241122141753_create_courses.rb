class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.references :course_type, null: false, foreign_key: true
      t.references :company, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.boolean :is_company, default: false
      t.date :from_date, null: false
      t.date :to_date
      t.string :code, limit: 10
      t.integer :year_number, null: false
      t.integer :general_number, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
