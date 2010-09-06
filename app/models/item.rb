class Item < ActiveRecord::Base
  
  belongs_to :order
  belongs_to :pair
  belongs_to :style
  
  validates_presence_of :size
  
  validates_numericality_of :size, :list_price, :discount
  
#  validates_numericality_of :discount   #, :allow_nil => true
  validates_numericality_of :percent_off, :only_integer => true 
  
  # Item Status constants
  
  ITEM_PENDING = 10
  ITEM_SOLD = 20
  ITEM_RETURN = 30
  
  ITEM_STATUS = [
    # display      value in DB
    [ "已售出",    ITEM_SOLD ],
    [ "保留中",    ITEM_PENDING ],
    [ "退回",      ITEM_RETURN ]
  ]
  
  
end
