class OrdersController < ApplicationController

  #--------------------------------------------------
  #  index
  #--------------------------------------------------
  def index
    
    if params[:incomplete] and params[:incomplete] == "true"
      @orders = Order.paginate :page => params[:page], 
                               :order => "purchase_date DESC, id DESC", 
                               :conditions => ["status <> ? and status <> ?", Order::ORDER_COMPLETE, Order::ORDER_CANCEL], 
                               :per_page => 50 
    else
      @orders = Order.paginate :page => params[:page], :order => "purchase_date DESC, id DESC", :per_page => 50      
    end
    @order_count = Order.count
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  #--------------------------------------------------
  #  show
  #--------------------------------------------------
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  #--------------------------------------------------
  #  new
  #--------------------------------------------------
  def new
    @order = Order.new
    if not params[:customer_id].blank?
      @customer = Customer.find(params[:customer_id])
      @order.customer = @customer
    end
    
    @order.purchase_date = Date.today
    
    @styles = Style.find_all_for_selection
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  #--------------------------------------------------
  #  search_customer
  #--------------------------------------------------
  def search_customer
    unless params[:search].blank?
      if params[:search] == "all"
        @customers = Customer.all(:order => 'membership')
      else
        @customers = Customer.find(:all, :conditions=> ["name like ?", "%" + params[:search] + "%"])      
      end
    else
      @customers = Array.new # return an empty array
    end
    # logger.info("----- rendering partial size=" + @customers.size.to_s)
    render :partial => 'search', :layout => false
  end

  #--------------------------------------------------
  #  get_inventory
  #--------------------------------------------------
  def get_inventory
    @pairs = Pair.find(:all, :conditions => { :style_id => params[:style_id] , :status => [Pair::BACK_ORDER, Pair::ON_SALE] }, :order => 'size')
    #logger.info("**************** FOUND " + @pairs.size.to_s + " pairs")
    render :partial => 'get_inventory', :layout => false
  end
 
  #--------------------------------------------------
  #  get_sizes
  #--------------------------------------------------
  def get_sizes
    unless params[:style_id].blank?
      @style = Style.find(params[:style_id])
      @temp_record = params[:temp_record]
      
      @sizes = Array.new
      
      for pair in @style.pairs
        #@sizes[@sizes.length] = pair.size if not @sizes.include?(pair.size) and pair.status == Pair::ON_SALE
        @sizes[@sizes.length] = pair.size if pair.status == Pair::ON_SALE
      end
      
      render :partial => 'get_sizes', :layout => false
    else
      render :nothing => true
    end
  end
  
  #--------------------------------------------------
  #  edit
  #--------------------------------------------------
  def edit
    @order = Order.find(params[:id])
    @styles = Style.find_all_for_selection
  end


  #--------------------------------------------------
  #  create
  #--------------------------------------------------
  def create
    @order = Order.new(remove_empty_item(params[:order]))

    respond_to do |format|
      if @order.save
        
        @order.items.each do |item|
          pair = Pair.find(:first, :conditions => ['style_id = ? and size = ? and status = ?', item.style_id, item.size, Pair::ON_SALE] )
          pair.status = Pair::SOLD
          item.pair_id = pair.id
          pair.save
          item.save
        end
        
        flash[:notice] = '出售紀錄新增成功！'
        format.html { redirect_to :controller => 'orders', :action => 'index' }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        @styles = Style.find_all_for_selection
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  update
  #--------------------------------------------------
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(remove_empty_item(params[:order]))
        flash[:notice] = '出售紀錄更新成功！'
        format.html { redirect_to :controller => 'orders', :action => 'index' }
        format.xml  { head :ok }
      else
        @styles = Style.find_all_for_selection
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  #--------------------------------------------------
  #  packing
  #--------------------------------------------------
  def packing
    @order = Order.find(params[:id])
    @styles = Style.find_all_for_selection
  end
  
  #--------------------------------------------------
  #  destroy
  #--------------------------------------------------
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  #--------------------------------------------------
  # remove_empty_item
  #
  # removes item that have not selected a style. Or when "updating" there's a weird NEW_RECORD.
  #--------------------------------------------------  
  def remove_empty_item(params)
#    logger.info("-------- BEGIN remove_empty_item");
    if params[:items_attributes]
      params[:items_attributes].keys.each do |key|
#        logger.info("----- key =  " + key)
        if params[:items_attributes][key][:style_id] == "" or key == 'NEW_RECORD' then
#          logger.info("----- removing key =  " + key)
          params[:items_attributes].delete(key) 
        end
      end
    end
#    logger.info("-------- END remove_empty_item");
    return params
  end
  
end
