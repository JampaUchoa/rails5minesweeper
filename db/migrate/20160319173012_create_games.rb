class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|

      t.text :board, array: true
      t.text :fog, array: true
      t.integer :size_x
      t.integer :size_y
      t.integer :bombs
      t.belongs_to :user, as: "winner_id"
      t.timestamps
    end
  end
end
