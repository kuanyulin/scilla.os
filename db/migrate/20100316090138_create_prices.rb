class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.integer :style_id, :null => false
      t.decimal :price, :precision => 7, :scale => 2
      t.time :start_date, :null => false, :default => Time.now

      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
