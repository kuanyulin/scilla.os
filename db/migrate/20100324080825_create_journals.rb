class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.date :entry_date
      t.string :title, :limit => 255
      t.boolean :balanced, :default => false
      t.integer :edited_by
      t.decimal :total_credit, :precision => 12, :scale => 2, :default => 0
      t.decimal :total_debit,  :precision => 12, :scale => 2, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :journals
  end
end
