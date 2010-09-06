class Pair < ActiveRecord::Base

  belongs_to :style
  belongs_to :refill
  has_many :items,
           :order => 'purchase_date, status DESC'
  
  validates_presence_of :style_id, :size
  validates_length_of :note, :maximum => 255

  # define some constants
  BACK_ORDER = 0
  ON_SALE = 10
  IN_TRANSIT = 20
  SOLD = 30
  BACK_ORDER_SOLD = 40
  DEFECT = 50
  
  PAIR_STATUS = [
    # display       value in DB, 0 is the default
    [ "訂製中",      BACK_ORDER ],
    [ "退回中",      IN_TRANSIT ],
    [ "訂製中（售）", BACK_ORDER_SOLD ],
    [ "發售中",      ON_SALE ],
    [ "已售出",      SOLD ],
    [ "瑕疵品",      DEFECT ]
  ]

end
