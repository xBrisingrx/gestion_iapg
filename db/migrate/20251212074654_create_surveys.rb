class CreateSurveys < ActiveRecord::Migration[8.0]
  def change
    create_table :surveys do |t|
      t.references :course, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.string :question, null: false
      t.string :answer

      t.timestamps
    end
  end
end
