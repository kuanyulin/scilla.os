class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :customer_id
      t.date    :purchase_date,   :null => false
      t.decimal :total_list_price, :precision => 7, :scale => 0, :default => 0
      t.decimal :total_discount,   :precision => 7, :scale => 0, :default => 0
      t.decimal :extra_discount,   :precision => 7, :scale => 0, :default => 0
      t.decimal :total_paid,       :precision => 7, :scale => 0, :default => 0
      t.integer :payment_type,     :size => 2
      t.integer :status,           :size => 2
      t.text    :note

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
