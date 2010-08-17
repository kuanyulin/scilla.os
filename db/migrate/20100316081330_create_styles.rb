class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      t.integer :vendor_id, :null => false
      t.string :name, :null => false
      t.string :vendor_model, :null => false
      t.string :at_model, :null => false
      t.text   :spec
      t.string :picture1
      t.string :picture2
      t.string :picture3
      t.string :picture5
      t.string :picture6
      t.string :thumbnail
      t.text :note
      t.decimal :cost, :precision => 7, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :styles
  end
end
