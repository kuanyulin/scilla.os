class Entry < ActiveRecord::Base
  
  belongs_to :account
  belongs_to :journal
  
  validates_presence_of :entry_date
  validates_numericality_of :credit, :debit
  validates_length_of :description, :maximum => 255
  
  def add_to_subtotal(subtotal)
    if account.is_debit_account
      return subtotal + debit - credit      
    end
      return subtotal - debit + credit
  end
  
end
