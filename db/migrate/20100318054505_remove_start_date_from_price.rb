class RemoveStartDateFromPrice < ActiveRecord::Migration
  def self.up
    remove_column :prices, :start_date
  end

  def self.down
    add_column :prices, :start_date, :time
  end
end
