class CreateIncoiveItems < ActiveRecord::Migration[8.0]
  def change
    create_table :incoive_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :course_people, null: false, foreign_key: true
      t.integer :status
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
