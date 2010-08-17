class AddPrivilegeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :privilege, :integer, :default => 0
  end

  def self.down
    remove_column :users, :privilege
  end
end
