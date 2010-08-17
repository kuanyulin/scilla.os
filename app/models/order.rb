class Order < ActiveRecord::Base
  
  validates_presence_of   :customer_id
  
  validates_length_of :recipient, :maximum => 80, :allow_blank => true
  validates_length_of :phone, :in => 7..20, :allow_blank => true
  validates_length_of :shipping_address, :maximum => 255, :allow_blank => true
  validates_length_of :order_number, :maximum => 40, :allow_blank => true
  
  belongs_to :customer
  
  has_many :items
  accepts_nested_attributes_for :items, :allow_destroy => true
  
  # Shipping method
  SHIP_BLACK_CAT = 10
  SHIP_FIRST_DEL = 20
  SHIP_CONV_STORE = 30
  SHIP_IN_STORE = 40
  SHIP_AT_DELIVER = 50
  
  SHIPPING_METHOD = [
    # display      value in DB
    [ "宅急便",      SHIP_BLACK_CAT ],
    [ "第一宅配",    SHIP_FIRST_DEL ],
    [ "超商取貨",    SHIP_CONV_STORE ],
    [ "現場取貨",    SHIP_IN_STORE ],
    [ "我們親送",    SHIP_AT_DELIVER ]
  ]
  
  # Payment type
  PAY_CREDIT_CARD = 10
  PAY_ATM  = 20
  PAY_IBON = 30
  PAY_CONV_STORE = 40
  PAY_ON_DELIVERY = 50
  PAY_IN_STORE = 60
  PAY_DIRECT_ATM = 70
  
  PAYMENT_TYPE = [
    # display      value in DB
    [ "線上刷卡",    PAY_CREDIT_CARD ],
    [ "線上ATM",    PAY_ATM ],
    [ "iBon",      PAY_IBON ],
    [ "超商付款",    PAY_CONV_STORE ],
    [ "貨到付款",    PAY_ON_DELIVERY ],
    [ "現場購買",    PAY_IN_STORE ],
    [ "直接匯款",    PAY_DIRECT_ATM ]
  ]
  
  # Order status
  ORDER_NEW = 10
  ORDER_PROCESSED = 20
  ORDER_SHIPPED = 30
  ORDER_BACK_ORDER = 40 
  ORDER_COMPLETE = 50
  ORDER_CANCEL = 60
  ORDER_PROBLEM = 70
  ORDER_EXCHANGE = 80
  ORDER_RETURN = 90
  
  ORDER_STATUS = [
    # display      value in DB
    [ "新進訂單",   ORDER_NEW ],
    [ "處理中",    ORDER_PROCESSED ],
    [ "已寄出",    ORDER_SHIPPED ],
    [ "訂製中",    ORDER_BACK_ORDER ],
    [ "完成",      ORDER_COMPLETE ],
    [ "取消",      ORDER_CANCEL ],
    [ "問題",      ORDER_PROBLEM ],
    [ "換尺寸",    ORDER_EXCHANGE ],
    [ "退貨退款",  ORDER_RETURN ]
  ]
  
  # Purchase location
  ORDER_OFFICE   = 10
  ORDER_RAKUTEN  = 20
  ORDER_PCHOME   = 30
  ORDER_PAYEASY  = 40
  ORDER_GOHAPPY  = 50
  ORDER_PHONE    = 60
  ORDER_YAHOOMALL = 70
  
  ORDER_LOCATION = [
    # display      value in DB
    [ "工作室",  ORDER_OFFICE ],
    [ "樂天",    ORDER_RAKUTEN ],
    [ "PChome", ORDER_PCHOME ], 
    [ "PayEasy", ORDER_PAYEASY ],
    [ "GoHappy", ORDER_GOHAPPY ],
    [ "電話電郵",  ORDER_PHONE ],
    [ "Yahoo商城", ORDER_YAHOOMALL ]
  ]
  
end
