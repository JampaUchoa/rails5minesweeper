class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|

      t.text :uuid, index: true
      t.text :status, index: true, default: "offline"
      t.boolean :online, index: true, null: false, default: false
      t.timestamps

    end
  end
end
