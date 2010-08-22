class CreatePairs < ActiveRecord::Migration
  def self.up
    create_table :pairs do |t|
      t.integer :style_id, :null => false
      t.integer :refill_id, :null => false
      t.decimal :size, :null => false, :precision => 3, :scale => 1
      t.integer :status, :default => 0, :null => false
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :pairs
  end
end
