class AddTotalPurchaseToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :total_purchase, :decimal, :precision => 7, :scale => 0, :default => 0
  end

  def self.down
    remove_column :customers, :total_purchase
  end
end
