class CustomersController < ApplicationController
  
  #--------------------------------------------------
  #  index
  #--------------------------------------------------
  def index
   # @customers = Customer.all
    @customers = Array.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end
  
  #--------------------------------------------------
  #  search
  #--------------------------------------------------
  def search
    unless params[:search].blank?
      if params[:search] == "all"
        @customers = Customer.all(:order => 'membership')
      else
        @customers = Customer.find(:all, :conditions=> ["name like ?", "%" + params[:search] + "%"])      
      end
    else
   @customers = Array.new
    end
    # logger.info("----- rendering partial size=" + @customers.size.to_s)
    render :partial => 'search', :layout => false
  end
  
  #--------------------------------------------------
  #  show
  #--------------------------------------------------
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  #--------------------------------------------------
  #  new
  #--------------------------------------------------
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  #--------------------------------------------------
  #  edit
  #--------------------------------------------------
  def edit
    @customer = Customer.find(params[:id])
  end

  #--------------------------------------------------
  #  create
  #--------------------------------------------------
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        flash[:notice] = '客戶「' + @customer.name + '」新增成功'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  update
  #--------------------------------------------------
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        flash[:notice] = 'Customer was successfully updated.'
        format.html { redirect_to(@customer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  destroy
  #--------------------------------------------------
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.xml  { head :ok }
    end
  end
 
  #--------------------------------------------------
  #  report
  #--------------------------------------------------
  def report
    #@elite_member = Customer.count(:conditions => ["membership = ?", Customer::ELITE_MEMBER])
    #@style_member = Customer.count(:conditions => ["membership = ?", Customer::STYLE_MEMBER])
    @customer_count = Customer.count
    @elite_members = Customer.all(:order => 'total_purchase DESC', :conditions => ["membership = ?", Customer::ELITE_MEMBER])
    @style_members = Customer.all(:order => 'total_purchase DESC', :conditions => ["membership = ?", Customer::STYLE_MEMBER])
    @standard_members = Customer.all(:order => 'total_purchase DESC', :conditions => ["membership = ?", Customer::STANDARD_MEMBER])
  end
  
  #--------------------------------------------------
  #  calculate_membership
  #--------------------------------------------------
  def calculate_membership
    @customers = Customer.all
    
    @idle_customers = Array.new
    @elite_member = 0
    @style_member = 0
  
    @customers.each do |customer|
      
      customer.total_purchase = 0
      
      if customer.orders
        customer.orders.each do |order|
          customer.total_purchase += order.total_paid          
        end
      else
        @idle_customers << customer
      end
      
      if customer.total_purchase > 14999
        customer.membership = Customer::ELITE_MEMBER
        @elite_member += 1
      elsif customer.total_purchase > 4999
        customer.membership = Customer::STYLE_MEMBER
        @style_member += 1
      else
        customer.membership = Customer::STANDARD_MEMBER
      end
      
      customer.save!
      
    end
    redirect_to :action => 'report'
  end
  
end
