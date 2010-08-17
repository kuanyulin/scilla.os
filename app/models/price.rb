class Price < ActiveRecord::Base
  
  belongs_to :style;
  
  validates_presence_of :price, :start_date
  validates_numericality_of :price
  
end
