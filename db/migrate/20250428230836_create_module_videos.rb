class CreateModuleVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :module_videos do |t|
      t.references :exam_module, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.integer :video_order, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
