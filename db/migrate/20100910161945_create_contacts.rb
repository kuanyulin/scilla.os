class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :customer_id
      t.date :contact_date
      t.text :content
      t.integer :method
      t.integer :status
      t.integer :contacted_by

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
