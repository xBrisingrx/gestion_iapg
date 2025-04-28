class CreateExams < ActiveRecord::Migration[8.0]
  def change
    create_table :exams do |t|
      t.string :title, null: false
      t.boolean :video
      t.string :retake, limit: 5
      t.boolean :elearning
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
