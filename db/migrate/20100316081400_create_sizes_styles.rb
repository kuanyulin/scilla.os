class CreateSizesStyles < ActiveRecord::Migration
  def self.up
    create_table :sizes_styles, :id => false do |t|
      t.integer :style_id, :null => false
      t.integer :size_id,  :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sizes_styles
  end
end
