class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.date    :entry_date
      t.string  :description , :limit => 255
      t.decimal :credit      , :precision => 12, :scale => 2, :default => 0
      t.decimal :debit       , :precision => 12, :scale => 2, :default => 0
      t.integer :account_id  , :null => false
      t.integer :journal_id  , :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
