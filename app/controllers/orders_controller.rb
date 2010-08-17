class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  def index
    #@orders = Order.all(:order => 'order_date DESC')
    if params[:incomplete] and params[:incomplete] == "true"
      @orders = Order.paginate :page => params[:page], 
                               :order => "order_date DESC", 
                               :conditions => ["status <> ? and status <> ?", Order::ORDER_COMPLETE, Order::ORDER_CANCEL], 
                               :per_page => 50 
    else
      @orders = Order.paginate :page => params[:page], :order => "order_date DESC", :per_page => 50      
    end
    @order_count = Order.count
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    if params[:customer_id].blank?
      flash[:notice] = '請從顧客資料頁新增訂單'
      redirect_to :controller => 'customers'
    else
      @customer = Customer.find(params[:customer_id])
      
      @order = Order.new
      @order.customer = @customer
      @order.recipient = @customer.name
      if @customer.mobile.blank?
        @order.phone = @customer.phone
      else
        @order.phone = @customer.mobile
      end
      @order.shipping_address = @customer.address
      
      @styles = Style.find_all_for_selection
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @order }
      end
    end    
  end

  def get_inventory
    @pairs = Pair.find(:all, :conditions => { :style_id => params[:style_id] , :status => [Pair::BACK_ORDER, Pair::ON_SALE] }, :order => 'size')
    #logger.info("**************** FOUND " + @pairs.size.to_s + " pairs")
    render :partial => 'get_inventory', :layout => false
  end
 
  
  def get_sizes
    unless params[:style_id].blank?
      @style = Style.find(params[:style_id])
      @temp_record = params[:temp_record]
      @sizes = @style.sizes;
      render :partial => 'get_sizes', :layout => false
    else
      render :nothing => true
    end
  end
  
  
  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @styles = Style.find_all_for_selection
  end


  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(remove_empty_item(params[:order]))

    respond_to do |format|
      if @order.save
        flash[:notice] = '訂單新增成功！'
        format.html { redirect_to :controller => 'customers', :action => 'show', :id => @order.customer_id  }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        @styles = Style.find_all_for_selection
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(remove_empty_item(params[:order]))
        flash[:notice] = '訂單更新成功！'
        format.html { redirect_to :controller => 'customers', :action => 'show', :id => @order.customer_id }
        format.xml  { head :ok }
      else
        @styles = Style.find_all_for_selection
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def packing
    @order = Order.find(params[:id])
    @styles = Style.find_all_for_selection
  end
  

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def remove_empty_item(params)
    if params[:items_attributes]
      params[:items_attributes].each_key { |key| params[:items_attributes].delete(key) if params[:items_attributes][key][:style_id] == "" }
    end
    return params
  end
  
end
