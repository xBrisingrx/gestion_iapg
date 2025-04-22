class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.string :answer, null: false
      t.boolean :correct, default: false
      t.integer :order
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
