class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :account_type, :limit => 2
      t.integer :subject_num , :limit => 2
      t.string  :subject     , :limit => 80
      t.string  :description , :limit => 255
      
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
