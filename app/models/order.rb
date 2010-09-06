class Order < ActiveRecord::Base
  
  # we can create purchse without customer now.
  #validates_presence_of   :customer_id
    
  belongs_to :customer
  
  validates_numericality_of :total_list_price, :total_discount, :extra_discount, :total_paid
 
  has_many :items
  accepts_nested_attributes_for :items, :allow_destroy => true
  
  # Payment type
  PAY_CREDIT_CARD = 10
  PAY_CASH  = 20
  PAY_CREDIT = 30
  
  PAYMENT_TYPE = [
    # display      value in DB
    [ "信用卡",    PAY_CREDIT_CARD ],
    [ "現金",    PAY_CASH ],
    [ "積點",      PAY_CREDIT ]
  ]
  
  # Order status
  ORDER_COMPLETE = 10
  ORDER_HOLD_PAID = 20
  ORDER_HOLD_UNPAID = 30 
  ORDER_BACK_ORDER = 40 
  ORDER_CANCEL = 50
  ORDER_EXCHANGE = 60
  ORDER_RETURN = 70
  ORDER_OTHER = 80
  
  ORDER_STATUS = [
    # display      value in DB
    [ "完成",      ORDER_COMPLETE ],
    [ "保留（已付）", ORDER_HOLD_PAID ],
    [ "保留（未付）", ORDER_HOLD_UNPAID ],
    [ "訂製中",    ORDER_BACK_ORDER ],
    [ "取消",      ORDER_CANCEL ],
    [ "換尺寸",    ORDER_EXCHANGE ],
    [ "退貨退款",  ORDER_RETURN ],
    [ "其他",      ORDER_OTHER ]
  ]
  
  
end
