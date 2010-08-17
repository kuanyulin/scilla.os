class AddPicture4ToStyle < ActiveRecord::Migration
  def self.up
    add_column :styles, :picture4, :string
  end

  def self.down
    remove_column :styles, :picture4
  end
end
