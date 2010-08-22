class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string  :name,         :limit => 80, :null => false
      t.date    :birthdate
      t.integer :membership,   :limit => 2
      t.string  :email,        :limit => 100
      t.string  :mobile,       :limit => 20
      t.string  :phone,        :limit => 20
      t.string  :address,      :limit => 255
      t.string  :bank,         :limit => 80
      t.string  :bank_account, :limit => 20
      t.decimal :total_purchase, :precision => 7, :scale => 0, :default => 0
      t.text    :note

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
