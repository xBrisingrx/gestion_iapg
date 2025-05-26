class CreateQuestionnaires < ActiveRecord::Migration[8.0]
  def change
    create_table :questionnaires do |t|
      t.string :question
      t.string :q_type
      t.integer :q_order

      t.timestamps
    end
  end
end
