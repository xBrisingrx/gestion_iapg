class CreateSectionals < ActiveRecord::Migration[8.0]
  def change
    create_table :sectionals do |t|
      t.string :name, null: false
      t.string :direction, null: false
      t.references :city, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
