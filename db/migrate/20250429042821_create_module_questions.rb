class CreateModuleQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :module_questions do |t|
      t.references :exam_module, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :question_order, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
