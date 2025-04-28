class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title, null: false, limit: 500
      t.string :file, limit: 100
      t.string :vimeo, limit: 100
      t.string :code, limit: 10
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
