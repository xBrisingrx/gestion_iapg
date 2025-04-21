class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :question, null: false
      t.boolean :eliminating, default: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
