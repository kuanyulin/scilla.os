class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.string :name, :null => false
      t.string :address
      t.string :contact1
      t.string :contact2
      t.string :phone1
      t.string :phone2
      t.string :fax
      t.string :bank_name
      t.string :bank_account
      t.string :tax_id
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :vendors
  end
end
