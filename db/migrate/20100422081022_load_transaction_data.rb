class LoadTransactionData < ActiveRecord::Migration
  def self.up
    f = File.open(RAILS_ROOT + "/db/migrate/init_data/orders.csv", 'r')
    
    # create refill
    old_date = Date.parse("2009-03-03")
    refill = Refill.new( :order_date => old_date, 
                         :arrive_date => old_date,
                         :description => "補已售出紀錄",
                         :made_by => 1,
                         :arrived => true )
    refill.save
    
    f.each_line do |line|
      cells = line.split(',')
      order_date    = Date.parse(cells[0]) 
      customer_name = cells[1].delete('"')
      style_name    = cells[2].delete('"')
      size          = cells[3].delete('"').to_f
      note          = cells[4].empty? ? "" : cells[4].delete('"')
      amount        = cells[5].delete('"').to_f
      location      = cells[6].delete('"')
      
      order_from = Order::ORDER_OFFICE
      if location.starts_with?("Pchome")
        order_from = Order::ORDER_PCHOME
      elsif location.starts_with?("樂天") 
        order_from = Order::ORDER_RAKUTEN
      end
      
      # find Customer
      customer = Customer.find_by_name(customer_name)
      
      # if not, create a new Customer
      if !customer
        customer = Customer.new(:name => customerName)
        customer.save
        puts "customer not found " + customer_name
      end
      
      style = Style.find_by_name( style_name )
      if !style
        puts "style not found " + style_name
      end
      
      # create a new Pair
      pair = Pair.new( :style_id  => style.id, 
                       :refill_id => refill.id, 
                       :size      => size, 
                       :special   => false, 
                       :status    => Pair::SOLD, 
                       :note      => "補記舊紀錄" )
      pair.save!
      
      # create a new Order
      order = Order.new( :customer_id => customer.id, 
                         :order_date  => order_date,
                         :recipient   => customer.name,
                         :total_amount => amount,
                         :paid_date    => order_date,
                         :status       => Order::ORDER_COMPLETE,
                         :order_from   => order_from,
                         :note         => "補記舊紀錄，可能需要修正" )
                         
      order.save!
      
      # create a new Item
      item = Item.new ( :order_id => order.id,
                        :pair_id  => pair.id,
                        :style_id => style.id,
                        :size     => size,
                        :price    => amount,
                        :status   => Item::ITEM_SHIPPED,
                        :note     => "補記舊紀錄，可能需要修正",
                        :shipped_date => order_date )
      
      item.save!
      
      puts "Created order[" + order.id.to_s + "] item[" + item.id.to_s + "] pair[" + pair.id.to_s + "] for " + customer.name
    end
  end

  def self.down
    Order.delete_all
    Item.delete_all
  end
  
  
  
  
end
