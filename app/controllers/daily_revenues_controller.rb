class DailyRevenuesController < ApplicationController
  # GET /daily_revenues
  # GET /daily_revenues.xml
  def index
    @daily_revenues = DailyRevenue.all :order => 'sale_date'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @daily_revenues }
    end
  end

  # GET /daily_revenues/1
  # GET /daily_revenues/1.xml
  def show
    @daily_revenue = DailyRevenue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @daily_revenue }
    end
  end

  # GET /daily_revenues/new
  # GET /daily_revenues/new.xml
  def new
    @daily_revenue = DailyRevenue.new
    @daily_revenue.sale_date = Date.today
    
    @last_entry = DailyRevenue.find(:first, :conditions => ["sale_date < ?", Date.today], :order => 'sale_date DESC' )
    @last_entry_reserve = @last_entry.nil? ? 0 : @last_entry.reserve_cash
    @accum_cash = @last_entry_reserve
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @daily_revenue }
    end
  end

  def get_last_reserve
    unless params[:sale_date].blank? 
      @target_date = Chronic::parse(params[:sale_date])
      @last_entry = DailyRevenue.find(:first, :conditions => ["sale_date < ?", @target_date], :order => 'sale_date DESC' )
        
      render :partial => 'get_last_reserve', :layout => false
    else
      render :nothing => true
    end
  end
  
  # GET /daily_revenues/1/edit
  def edit
    @daily_revenue = DailyRevenue.find(params[:id])
    @last_entry = DailyRevenue.find(:first, :conditions => ["sale_date < ?", @daily_revenue.sale_date], :order => 'sale_date DESC' )
    @last_entry_reserve = @last_entry.nil? ? 0 : @last_entry.reserve_cash
    @accum_cash = @daily_revenue.cash + @last_entry_reserve
  end

  # POST /daily_revenues
  # POST /daily_revenues.xml
  def create
    @daily_revenue = DailyRevenue.new(params[:daily_revenue])

    respond_to do |format|
      if @daily_revenue.save
        flash[:notice] = '日營業額新增成功'
        format.html { redirect_to :action => "index" } 
        format.xml  { render :xml => @daily_revenue, :status => :created, :location => @daily_revenue }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @daily_revenue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /daily_revenues/1
  # PUT /daily_revenues/1.xml
  def update
    @daily_revenue = DailyRevenue.find(params[:id])

    respond_to do |format|
      if @daily_revenue.update_attributes(params[:daily_revenue])
        flash[:notice] = 'DailyRevenue was successfully updated.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @daily_revenue.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_revenues/1
  # DELETE /daily_revenues/1.xml
  def destroy
    @daily_revenue = DailyRevenue.find(params[:id])
    @daily_revenue.destroy

    respond_to do |format|
      format.html { redirect_to(daily_revenues_url) }
      format.xml  { head :ok }
    end
  end
end
