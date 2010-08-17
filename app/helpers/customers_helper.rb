module CustomersHelper
  
  # MEMBER_STATUS = [
  #  [ "一般會員",      STANDARD_MEMBER ],
  #  [ "風格會員",      STYLE_MEMBER ],
  #  [ "頂級會員",      ELITE_MEMBER ]
  # ]
  
  def show_member_icon(level, big=false)
    case level
      when Customer::STANDARD_MEMBER
        if big
          return image_tag('heart-blue_32.png', :alt => "一般會員", :border => 0)
        else
          return image_tag('heart-blue_16.png', :alt => "一般會員", :border => 0)
        end
      when Customer::STYLE_MEMBER
        if big
          return image_tag('heart-gold_32.png', :alt => "風格會員", :border => 0)  
        else
          return image_tag('heart-gold_16.png', :alt => "風格會員", :border => 0)  
        end
      when Customer::ELITE_MEMBER
        if big
          return image_tag('heart-pink_32.png', :alt => "頂級會員", :border => 0)
        else
          return image_tag('heart-pink_16.png', :alt => "頂級會員", :border => 0)
        end
      end
      
    return ""
  end
  
end
