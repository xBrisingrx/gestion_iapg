class CreateCourseTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :course_types do |t|
      t.string :name, null: false, limit: 100
      t.string :description, null: false
      t.integer :max_quota, null: false
      t.integer :min_quota, null: false
      t.integer :min_score, null: false
      t.integer :max_score, null: false
      t.integer :passing_score, null: false
      t.integer :number_of_repeat, null: false
      t.boolean :need_code, default: false
      t.integer :fleet, null: false
      t.string :category, null: false
      t.references :room, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
