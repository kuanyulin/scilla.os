class CreateCategoriesStyles < ActiveRecord::Migration
  def self.up
    create_table :categories_styles, :id => false do |t|
      t.integer :style_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :categories_styles
  end
end
