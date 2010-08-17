class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.all(:order => "account_type, subject_num")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end
  
  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = '科目增新成功'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = '科目更新成功'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def income_statement
    @has_report = false
    if params[:range] != nil
      @start_date = Date.civil(params[:range][:"start_date(1i)"].to_i, params[:range][:"start_date(2i)"].to_i, params[:range][:"start_date(3i)"].to_i)
      @end_date   = Date.civil(params[:range][:"end_date(1i)"].to_i,   params[:range][:"end_date(2i)"].to_i,   params[:range][:"end_date(3i)"].to_i)
      @report = make_income_statement(@start_date, @end_date)
      @has_report = true
      respond_to do |format|
        format.html # show.html.erb
        #format.xml  { render :xml => @account }
      end
    else
      respond_to do |format|
        format.html # show.html.erb
        #format.xml  { render :xml => @account }
      end
    end
  end
  
  private 
  
  def make_income_statement(from_date, to_date) 
    report = Hash.new
    sales = Account.find_by_id(17)
    sales_return = Account.find_by_id(18)
    service_income = Account.find_by_id(19)
    
    report[:sales_income]   = subtotal_credit_account(sales.entries, from_date, to_date)
    report[:sales_return]   = subtotal_debit_account(sales_return.entries, from_date, to_date)
    report[:service_income] = subtotal_credit_account(service_income.entries, from_date, to_date)
    report[:gross_income] = report[:sales_income] + report[:service_income] - report[:sales_return]
    
    # Get costs (debits accnt)
    cost_accnts = Account.find(:all, :conditions => { :subject_num => 5000..5999})
    costs = Hash.new
    cost_total = 0
    cost_accnts.each do |acct|
      subtotal = subtotal_debit_account(acct.entries, from_date, to_date)
      if subtotal > 0
        costs[acct.subject] = [acct, subtotal]
        cost_total += subtotal
      end
    end
    report[:costs] = costs
    
    # Get expenses (debits accnt)
    exp_accnts = Account.find(:all, :conditions => { :subject_num => 6000..6999})
    expenses = Hash.new
    expense_total = 0
    exp_accnts.each do |acct|
      subtotal = subtotal_debit_account(acct.entries, from_date, to_date)
      if subtotal > 0
        expenses[acct.subject] = [acct, subtotal]
        expense_total += subtotal
      end
    end
    report[:expenses] = expenses
    
    report[:expense_costs] = expense_total + cost_total
    report[:net_income] = report[:gross_income] - report[:expense_costs]
    
    return report
  end
  
  #--------------------------------------
  #
  #--------------------------------------
  def subtotal_debit_account(entries, from_date, to_date)
    subtotal = 0
    unless entries == nil or entries.size == 0
      entries.each do |e|
        if e.entry_date >= from_date and e.entry_date <= to_date
          logger.info("***** found a debit entry " + e.debit.to_s + " : " + e.credit.to_s)
          subtotal = subtotal + e.debit - e.credit 
        end
      end
    end
    logger.info("***** return debit " + subtotal.to_s)
    return subtotal
  end
  
  #--------------------------------------
  #
  #--------------------------------------
  def subtotal_credit_account(entries, from_date, to_date)
    subtotal = 0
    unless entries == nil or entries.size == 0
      entries.each do |e|
        if e.entry_date >= from_date and e.entry_date <= to_date
          logger.info("***** found a credit entry " + e.debit.to_s + " : " + e.credit.to_s)
          subtotal = subtotal + e.credit - e.debit
        end
      end
    end
    logger.info("***** return credit " + subtotal.to_s)
    return subtotal
  end
  
end
