class DailyRevenue < ActiveRecord::Base

  belongs_to :user,
             :class_name => "User",
             :foreign_key => "made_by"

  validates_numericality_of :revenue, :credit_card, :cash, :cash_deposit, 
    :reserve_cash, :total_discount, :total_extra


  def before_save
      self.sale_date = Chronic::parse(self.sale_date_before_type_cast) if attribute_present?("sale_date")
  end
  
end
