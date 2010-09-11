class Contact < ActiveRecord::Base

  belongs_to :customer
  
  belongs_to :user,
             :class_name => "User",
             :foreign_key => "contacted_by"
             
  # contact method
  SMS = 10
  EMAIL  = 20
  PHONE = 30
  
  CONTACT_METHODS = [
    # display      value in DB
    [ "簡訊",    SMS ],
    [ "email",    EMAIL ],
    [ "電話",      PHONE ]
  ]
  
  # status
  OK = 10
  NEED_FOLLOWUP  = 20
  
  CONTACT_STATUS = [
    # display      value in DB
    [ "OK",    OK ],
    [ "需追蹤",    NEED_FOLLOWUP ]
  ]
  
end
