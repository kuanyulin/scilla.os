class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :order_id
      t.integer :pair_id
      t.integer :style_id
      t.decimal :size, :precision => 3, :scale => 1
      t.decimal :list_price,    :precision => 7, :scale => 0, :default => 0
      t.decimal :discount,      :precision => 7, :scale => 0, :default => 0
      t.decimal :paid_amount,   :precision => 7, :scale => 0, :default => 0
      t.integer :percent_off,   :default => 0
      t.integer :status, :size => 2
      t.date    :purchase_date, :null => false
      t.text    :note

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
