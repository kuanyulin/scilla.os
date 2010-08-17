class Account < ActiveRecord::Base

  has_many :entries, :order => "entry_date"
  
  validates_presence_of :subject, :subject_num
  validates_numericality_of :subject_num
  validates_uniqueness_of :subject_num
  validates_length_of :description, :maximum => 255
  validates_length_of :subject,     :maximum => 80
  
  ACCOUNT_TYPES = [
    # display       value in DB, 1000 is the default
    [ "資產 Assets",      1000 ],
    [ "負債 Liabilities", 2000 ],
    [ "股東權益 Shareholder's Equity", 3000 ],
    [ "營業收入 Operating Income", 4000 ],
    [ "營業成本 Operating Cost", 5000 ],
    [ "營業費用 Operating Expense", 6000 ],
    [ "其他受入與支出 Other Income/Expense", 7000 ]
  ] # 7000-7499 income, 7500-7999 loss.
  
  # debit accounts: 1000, 5000, 6000, 7500
  # credit accounts: 2000, 3000, 4000, 7000
  
  def is_debit_account
    if (subject_num >= 2000 and subject_num <= 4999) or (subject_num >= 7500)
      return false
    else
      return true
    end
  end
  
  
end
