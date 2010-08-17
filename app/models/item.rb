class Item < ActiveRecord::Base
  
  belongs_to :order
  belongs_to :pair
  belongs_to :style
  validates_presence_of :size
  
  validates_numericality_of :discount, :allow_nil => true
  validates_numericality_of :price, :size
  
  # Item Status constants
  
  ITEM_PENDING = 10
  ITEM_SHIPPED = 20
  ITEM_RETURN = 30
  
  ITEM_STATUS = [
    # display      value in DB
    [ "未完成",    ITEM_PENDING ],
    [ "已寄出",    ITEM_SHIPPED ],
    [ "退回",      ITEM_RETURN ]
  ]
  
  
end
