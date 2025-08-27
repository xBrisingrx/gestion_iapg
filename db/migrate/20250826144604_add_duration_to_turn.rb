class AddDurationToTurn < ActiveRecord::Migration[8.0]
  def change
    add_column :turns, :duration, :integer, default: 0
  end
end
