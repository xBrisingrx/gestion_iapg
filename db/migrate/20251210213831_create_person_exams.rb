class CreatePersonExams < ActiveRecord::Migration[8.0]
  def change
    create_table :person_exams do |t|
      t.references :person, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: true, foreign_key: true
      t.integer :instance, null: false, default: 1

      t.timestamps
    end
  end
end
