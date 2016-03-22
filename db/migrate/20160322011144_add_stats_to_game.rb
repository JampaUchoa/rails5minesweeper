class AddStatsToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :winner_uuid, :string
    add_index :games, :winner_uuid
    add_column :games, :winner_score, :integer
  end
end
