class CreateDailyRevenues < ActiveRecord::Migration
  def self.up
    create_table :daily_revenues do |t|
      t.date :sale_date,         :null => false
      t.decimal :revenue,        :precision => 7, :scale => 0, :default => 0
      t.decimal :credit_card,    :precision => 7, :scale => 0, :default => 0
      t.decimal :cash,           :precision => 7, :scale => 0, :default => 0
      t.decimal :cash_deposit,    :precision => 7, :scale => 0, :default => 0
      t.decimal :reserve_cash,   :precision => 7, :scale => 0, :default => 0
      t.decimal :total_discount, :precision => 7, :scale => 0, :default => 0
      t.decimal :total_extra,    :precision => 7, :scale => 0, :default => 0
      t.integer :made_by
      
      t.timestamps
    end
  end

  def self.down
    drop_table :daily_revenues
  end
end
