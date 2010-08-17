module PairsHelper
  
  def show_pair_status(status)
    color = '#000000'
    
    case status
      when Pair::BACK_ORDER
        color = '#cc0000'
      when Pair::IN_TRANSIT
        color = '#7777DD'
      when Pair::ON_SALE
        color = '#228822'
      when Pair::BACK_ORDER_SOLD
        color = '#9e6627'
      when Pair::SOLD
        color = '#9e6627'
      when Pair::DEFECT
        color = '#666'
    end
    
    return "<font color='" + color + "'>" + Pair::PAIR_STATUS.rassoc(status)[0] + "</font>"
  end

  
end
