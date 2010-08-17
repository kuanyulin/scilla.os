class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :customer_id,     :null => false
      t.date    :order_date,         :null => false
      t.string  :recipient,        :limit => 80
      t.string  :phone,            :limit => 20
      t.string  :shipping_address, :limit => 255
      t.integer :shipping_method, :size => 2
      t.decimal :shipping_charge, :precision => 7, :scale => 0, :default => 0
      t.decimal :total_amount,    :precision => 7, :scale => 0, :default => 0
      t.integer :payment_type,    :size => 2
      t.date    :paid_date
      t.integer :status,          :size => 2
      t.integer :order_from,      :size => 2
      t.string  :order_number,     :size => 40
      t.text    :note

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
