class CreateExamModules < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_modules do |t|
      t.references :exam, null: false, foreign_key: true
      t.string :name, null: false
      t.string :quote_type, null: false
      t.integer :module_order, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
