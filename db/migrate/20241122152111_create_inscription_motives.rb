class CreateInscriptionMotives < ActiveRecord::Migration[8.0]
  def change
    create_table :inscription_motives do |t|
      t.string :name, null: false, limit: 50
      t.string :description
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :inscription_motives, :name, unique: true
  end
end
