class CreateManagers < ActiveRecord::Migration[8.0]
  def change
    create_table :managers do |t|
      t.references :company, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.string :email, null: false
      t.string :job
      t.boolean :notifications, default: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
