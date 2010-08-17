class CreateSizes < ActiveRecord::Migration
  def self.up
    create_table :sizes do |t|
      t.decimal :size, :null => false, :precision => 3, :scale => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :sizes
  end
end
