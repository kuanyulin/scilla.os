# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def show_currency(price, hide_zero = true)
    
    return "" if price.nil?
    
    if price == 0
      return hide_zero ? "" : "0"
    else
#      begin
          parts = number_with_delimiter(price).split('.')
          integer_part = parts[0]
          if Float(price) >= 0.00
            "$ " + integer_part
          else
            '($ ' + integer_part.gsub(/^-/, '') + ')'
            #'-' + unit + delimitered_number.gsub(/^-/, '')
          end
#        rescue
#          price
#        end
      #return "$" + number_with_delimiter(price)
    end
  end
  
  def show_yes(aboolean)
    if aboolean 
      return image_tag('check_16.png', :alt => "", :border => 0)
    end
    return ""
  end

  def show_no(aboolean)
    if aboolean 
      return image_tag('delete_16.png', :alt => "", :border => 0)
    end
    return ""
  end

  def show_yes_no(aboolean)
    if aboolean 
      return image_tag('check_16.png', :alt => "", :border => 0)
    end
    return image_tag('delete_16.png', :alt => "", :border => 0)
  end
  
  def edit_image
    image_tag("edit_16.png", :border=>0, :alt => "更新")  
  end
  
  #-----------------------------------------------
  #  record_previous_page
  #
  #  
  #-----------------------------------------------
  def record_previous_page
    hidden_field_tag 'return_to_url', request.referer
  end
  
end
