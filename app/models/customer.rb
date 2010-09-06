class Customer < ActiveRecord::Base
  
  validates_presence_of   :name
  
  has_many :orders, :order => "purchase_date DESC"
  
  #validates_format_of :email,
  #                    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
  #                   :message => "地址格式錯誤"
  
  #validates_length_of :phone, :in => 7..20, :allow_blank => true
  #validates_length_of :mobile, :in => 10..20, :allow_blank => true
  validates_length_of :bank, :maximum => 80, :allow_blank => true
  validates_length_of :bank_account, :maximum => 20, :allow_blank => true
  
  # define some constants
  STANDARD_MEMBER = 10
  STYLE_MEMBER = 20
  ELITE_MEMBER = 30
  
  MEMBER_STATUS = [
    # display    value in DB, 10 is the default
    [ "一般會員",      STANDARD_MEMBER ],
    [ "風格會員",      STYLE_MEMBER ],
    [ "頂級會員",      ELITE_MEMBER ]
  ]
  
end
