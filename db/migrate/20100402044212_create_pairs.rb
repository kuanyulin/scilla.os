class CreatePairs < ActiveRecord::Migration
  def self.up
    create_table :pairs do |t|
      t.integer :style_id, :null => false
      t.integer :refill_id, :null => false
      t.integer :item_id
      t.decimal :size, :null => false, :precision => 3, :scale => 1
      t.boolean :special, :default => false, :null => false
      t.integer :status, :default => 0, :null => false
      t.boolean :at_rakuten, :default => false, :null => false
      t.boolean :at_pchome, :default => false, :null => false
      t.boolean :at_gohappy, :default => false, :null => false
      t.boolean :at_payeasy, :default => false, :null => false
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :pairs
  end
end
