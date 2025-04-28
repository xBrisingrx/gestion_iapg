class CreateExamQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_questions do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :question_order
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
