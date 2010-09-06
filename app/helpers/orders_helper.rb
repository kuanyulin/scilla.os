module OrdersHelper
  
  def show_order_status(status)
    color = '#000000'
    
    case status
      when Order::ORDER_COMPLETE
        color = '#7777DD'
      when Order::ORDER_HOLD_PAID
        color = '#cc0000'
      when Order::ORDER_HOLD_UNPAID
        color = '#849519'
      when Order::ORDER_BACK_ORDER
        color = '#cc0000'
      when Order::ORDER_CANCEL
        color = '#333333'
      when Order::ORDER_EXCHANGE
        color = '#dd0000'
      when Order::ORDER_RETURN
        color = '#dd0000'      
      when Order::ORDER_OTHER
        color = '#dd0000'
    end
    
    return "<font color='" + color + "'>" + Order::ORDER_STATUS.rassoc(status)[0] + "</font>"
  end
  
end
