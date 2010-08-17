class CreateRefills < ActiveRecord::Migration
  def self.up
    create_table :refills do |t|
      t.date :order_date
      t.date :arrive_date
      t.boolean :arrived, :default => false, :null => false
      t.string :description, :limit => 255
      t.integer :made_by
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :refills
  end
end
