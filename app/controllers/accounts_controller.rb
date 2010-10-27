class AccountsController < ApplicationController
  # -------------------------------------
  # index
  # -------------------------------------
  def index
    @accounts = Account.all(:order => "account_type, subject_num")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # -------------------------------------
  # show
  # -------------------------------------
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end
  
  # -------------------------------------
  # new
  # -------------------------------------
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # -------------------------------------
  # edit
  # -------------------------------------
  def edit
    @account = Account.find(params[:id])
  end

  # -------------------------------------
  # create
  # -------------------------------------
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

  # -------------------------------------
  # update
  # -------------------------------------
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

  # -------------------------------------
  # destroy
  # -------------------------------------
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end

  # -------------------------------------
  # income_statement
  # -------------------------------------
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

  # -------------------------------------
  # financial_reports
  # -------------------------------------
  def financial_reports
    @has_report = false
    if params[:range] != nil
      @start_date = Date.civil(params[:range][:"start_date(1i)"].to_i, params[:range][:"start_date(2i)"].to_i, params[:range][:"start_date(3i)"].to_i)
      @end_date   = Date.civil(params[:range][:"end_date(1i)"].to_i,   params[:range][:"end_date(2i)"].to_i,   params[:range][:"end_date(3i)"].to_i)
      @reports = make_financial_reports(@start_date, @end_date)
      @has_report = true
      respond_to do |format|
        format.html 
      end
    else
      respond_to do |format|
        format.html 
      end
    end
  end
  
  private 

  # -------------------------------------
  # make_financial_reports
  # -------------------------------------
  def make_financial_reports(from_date, to_date)
    reports = Hash.new
    reports[:assets] = get_accounts(1000, 1999, true, from_date, to_date)
    reports[:costs]  = get_accounts(5000, 6999, true, from_date, to_date)
    reports[:liabs]  = get_accounts(2000, 2999, false, from_date, to_date)
    reports[:shares] = get_accounts(3000, 3999, false, from_date, to_date)
    reports[:income] = get_accounts(4000, 4999, false, from_date, to_date)
    reports[:morein] = get_accounts(7000, 7999, false, from_date, to_date)

    return reports
  end

  # -------------------------------------
  # get_accounts
  # -------------------------------------
  def get_accounts(fromAcct, toAcct, debit, from_date, to_date)
    accounts = Hash.new
    
    accts = Account.find(:all, :conditions => { :subject_num => fromAcct..toAcct})
    accts.each do |acct|
      subtotal = subtotal_account(acct.entries, debit, from_date, to_date)
      accounts[acct.subject] = [acct, subtotal ] if subtotal > 0
    end
    
    return accounts
  end
  
  # -------------------------------------
  # make_income_statement
  # -------------------------------------  
  def make_income_statement(from_date, to_date) 
    report = Hash.new
    sales = Account.find_by_id(17)
    sales_return = Account.find_by_id(18)
    service_income = Account.find_by_id(19)
    
    report[:sales_income]   = subtotal_account(sales.entries, false, from_date, to_date)
    report[:sales_return]   = subtotal_account(sales_return.entries, true, from_date, to_date)
    report[:interest_inc]   = subtotal_account(interest_income.entries, false, from_date, to_date)
    report[:service_income] = subtotal_account(service_income.entries, false, from_date, to_date)
    report[:gross_income] = report[:sales_income] + report[:interest_inc] + report[:service_income] - report[:sales_return]
    
    # Get costs (debits accnt)
    cost_accnts = Account.find(:all, :conditions => { :subject_num => 5000..5999})
    costs = Hash.new
    cost_total = 0
    cost_accnts.each do |acct|
      subtotal = subtotal_account(acct.entries, true, from_date, to_date)
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
      subtotal = subtotal_account(acct.entries, true, from_date, to_date)
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
  # subtotal_account
  #--------------------------------------
  def subtotal_account(entries, debit, from_date, to_date)
    subtotal = 0
    unless entries == nil or entries.size == 0
      entries.each do |e|
        if e.entry_date >= from_date and e.entry_date <= to_date
          if debit
            subtotal = subtotal + e.debit - e.credit
          else
            subtotal = subtotal + e.credit - e.debit
          end
        end
      end
    end
    return subtotal
  end
  
end
