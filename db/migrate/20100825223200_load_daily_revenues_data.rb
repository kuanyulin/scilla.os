require 'active_record/fixtures'

class LoadDailyRevenuesData < ActiveRecord::Migration
  def self.up
    directory = File.join(File.dirname(__FILE__), 'init_data')
    Fixtures.create_fixtures(directory, "daily_revenues")
    
    revenues = DailyRevenue.find(:all, :order => 'sale_date')
   
    revenues.each do |daily_revenue|
      if daily_revenue.credit_card > 0 then
        description = daily_revenue.sale_date.to_s + " 信用卡營業額"
        amount = (daily_revenue.credit_card * 0.98).round
        entry_date = daily_revenue.sale_date + 1
        journal = Journal.new(:title => description,
                              :edited_by => 1,
                              :entry_date => entry_date,
                              :total_credit => amount, 
                              :total_debit => amount)
        journal.entries = Array.new
        # 富邦銀行 id = 2
        journal.entries[0] = Entry.new(:entry_date => entry_date,
                                       :account_id => 2,
                                       :description => description,
                                       :debit => amount,
                                       :credit => 0)
        # 營業收入 id = 17
        journal.entries[1] = Entry.new(:entry_date => entry_date,
                                       :account_id => 17,
                                       :description => description,
                                       :debit => 0,
                                       :credit => amount)                        
        journal.save
      end
      
      if daily_revenue.cash_deposit > 0 then
        description = daily_revenue.sale_date.to_s + " 收入現金存入"
        amount = daily_revenue.cash_deposit
        entry_date = daily_revenue.sale_date
        journal = Journal.new(:title => description,
                              :edited_by => 1,
                              :entry_date => entry_date,
                              :total_credit => amount, 
                              :total_debit => amount)
        journal.entries = Array.new
        # 聯邦銀行 id = 3
        journal.entries[0] = Entry.new(:entry_date => entry_date,
                                       :account_id => 3,
                                       :description => description,
                                       :debit => amount,
                                       :credit => 0)
        # 營業收入 id = 17
        journal.entries[1] = Entry.new(:entry_date => entry_date,
                                       :account_id => 17,
                                       :description => description,
                                       :debit => 0,
                                       :credit => amount)                        
        journal.save
      end  
    end
  end

  def self.down
    DailyRevenue.delete_all
  end
  
  
end
