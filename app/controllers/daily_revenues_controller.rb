class DailyRevenuesController < ApplicationController
  #--------------------------------------------------
  #  index
  #--------------------------------------------------
  def index
    @daily_revenues = session[:user].is_manager ? 
      DailyRevenue.all(:order => 'sale_date') : 
      DailyRevenue.find(:all, :conditions => ["sale_date < ? and sale_date > ?", Date.today, Date.today - 7], :order => 'sale_date')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @daily_revenues }
    end
  end

  #--------------------------------------------------
  #  monthly_revenue
  #--------------------------------------------------
  def monthly_revenue
    
    begin
      if not params[:start_date].blank? and not params[:end_date].blank?
        startTime = Chronic.parse(params[:start_date])
        endTime   = Chronic.parse(params[:end_date])
        @start_date = Date.parse(startTime.strftime('%Y-%m-%d'))
        @end_date   = Date.parse(endTime.strftime('%Y-%m-%d'))
      else
        @start_date = Date.parse(Chronic.parse('1 month ago').strftime('%Y-%m-%d'))
        @end_date = Date.today
      end
      @records = DailyRevenue.find(:all, :conditions => ["sale_date <= ? and sale_date >= ?", @end_date, @start_date], :order => 'sale_date')
    rescue Exception
      flash[:notice] = "試試輸入「today」「yesterday」或「2010/7/3」日期格式..."
      @records = Array.new
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @daily_revenues }
    end
  end
  
  #--------------------------------------------------
  #  show
  #--------------------------------------------------
  def show
    @daily_revenue = DailyRevenue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @daily_revenue }
    end
  end

  #--------------------------------------------------
  #  new
  #--------------------------------------------------
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

  #--------------------------------------------------
  #  get_last_reserve
  #--------------------------------------------------
  def get_last_reserve
    unless params[:sale_date].blank? 
      @target_date = Chronic::parse(params[:sale_date])
      @last_entry = DailyRevenue.find(:first, :conditions => ["sale_date < ?", @target_date], :order => 'sale_date DESC' )
        
      render :partial => 'get_last_reserve', :layout => false
    else
      render :nothing => true
    end
  end
  
  #--------------------------------------------------
  #  edit
  #--------------------------------------------------
  def edit
    @daily_revenue = DailyRevenue.find(params[:id])
    @last_entry = DailyRevenue.find(:first, :conditions => ["sale_date < ?", @daily_revenue.sale_date], :order => 'sale_date DESC' )
    @last_entry_reserve = @last_entry.nil? ? 0 : @last_entry.reserve_cash
    @accum_cash = @daily_revenue.cash + @last_entry_reserve
  end

  #--------------------------------------------------
  #  create
  #--------------------------------------------------
  def create
    logger.info("**************** daily_revenues_controller.create")
    @daily_revenue = DailyRevenue.new(params[:daily_revenue])
    
    if @daily_revenue.credit_card > 0 then
      description = @daily_revenue.sale_date.to_s + " 信用卡營業額"
      amount = (@daily_revenue.credit_card * 0.98).round
      entry_date = @daily_revenue.sale_date + 1
      journal = Journal.new(:title => description,
                            :edited_by => session[:user] ? session[:user].id : 1,
                            :entry_date => entry_date,
                            :total_credit => amount, 
                            :total_debit => amount)
      journal.entries = Array.new
      # 富邦銀行 id = 2
      journal.entries[0] = Entry.new(:entry_date => entry_date,
                                     :account_id => 2,
                                     :description => description,
                                     :debit => amount,
                                     :credit => 0)
      # 營業收入 id = 17
      journal.entries[1] = Entry.new(:entry_date => entry_date,
                                     :account_id => 17,
                                     :description => description,
                                     :debit => 0,
                                     :credit => amount)                        
      journal.save
    end
    
    if @daily_revenue.cash_deposit > 0 then
      description = @daily_revenue.sale_date.to_s + " 收入現金存入"
      amount = @daily_revenue.cash_deposit
      entry_date = @daily_revenue.sale_date
      journal = Journal.new(:title => description,
                            :edited_by => session[:user] ? session[:user].id : 1,
                            :entry_date => entry_date,
                            :total_credit => amount, 
                            :total_debit => amount)
      journal.entries = Array.new
      # 聯邦銀行 id = 3
      journal.entries[0] = Entry.new(:entry_date => entry_date,
                                     :account_id => 3,
                                     :description => description,
                                     :debit => amount,
                                     :credit => 0)
      # 營業收入 id = 17
      journal.entries[1] = Entry.new(:entry_date => entry_date,
                                     :account_id => 17,
                                     :description => description,
                                     :debit => 0,
                                     :credit => amount)                        
      journal.save
    end
    
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

  #--------------------------------------------------
  #  update
  #--------------------------------------------------
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

  #--------------------------------------------------
  #  destroy
  #--------------------------------------------------
  def destroy
    @daily_revenue = DailyRevenue.find(params[:id])
    @daily_revenue.destroy

    respond_to do |format|
      format.html { redirect_to(daily_revenues_url) }
      format.xml  { head :ok }
    end
  end
end
