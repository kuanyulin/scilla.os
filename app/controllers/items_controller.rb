class ItemsController < ApplicationController
  # GET /items
  # GET /items.xml
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @style = Style.find(@item.style_id)
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to(@item) }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    if @item.update_attributes(params[:item])
        
        if params[:item][:pair_id] and ! params[:item][:pair_id].blank?
          @pair = Pair.find(@item.pair_id)
          
          logger.info("********** ItemController.update -- changing pair status")
          if @pair.status == Pair::ON_SALE
            @pair.status = Pair::SOLD
          elsif @pair.status == Pair::BACK_ORDER
            @pair.status = Pair::BACK_ORDER_SOLD
          end
          @pair.save
        else
          @item.pair = nil
          @item.save!
        end
        
        flash[:notice] = 'Item was successfully updated.'
        redirect_to :controller => 'orders', :action => 'packing', :id => @item.order_id
    else
        render :action => "edit" 
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end
  
  def calculate_COGS
    @has_result = false
    if params[:range] != nil
      
      @start_date = Date.civil(params[:range][:"start_date(1i)"].to_i, params[:range][:"start_date(2i)"].to_i, params[:range][:"start_date(3i)"].to_i)
      @end_date   = Date.civil(params[:range][:"end_date(1i)"].to_i,   params[:range][:"end_date(2i)"].to_i,   params[:range][:"end_date(3i)"].to_i)
      
      if params[:use_order_date] == '0'
        orders = Order.find(:all, :conditions => { :order_date => @start_date..@end_date}, :order => 'order_date' )
        @items = Array.new
        orders.each do |order|
          order.items.each do |item|
            @items << item if not item.cancelled  
          end
        end
      else
        @items = Item.find(:all, :conditions => { :shipped_date => @start_date..@end_date, :cancelled => false, :status => Item::ITEM_SHIPPED }, :order => 'shipped_date' )         
      end

      @total_COGS = 0
      @total_sales = 0
      @total_discount = 0
      @items.each do |item|
        @total_COGS += item.style.cost
        @total_sales += item.price
        @total_discount += item.discount
      end
      @net_income = @total_sales - @total_discount - @total_COGS
      
      @has_result = true
      respond_to do |format|
        format.html
      end
    else
      respond_to do |format|
        format.html 
      end
    end
  end
  
end
