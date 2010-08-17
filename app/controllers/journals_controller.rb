class JournalsController < ApplicationController
  # GET /journals
  # GET /journals.xml
  def index
    #@journals = Journal.all(:order => "entry_date")
    @journals = Journal.paginate :page => params[:page], :order => "entry_date DESC", :per_page => 50
    @journal_count = Journal.count
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @journals }
    end
  end

  # GET /journals/1
  # GET /journals/1.xml
  def show
    @journal = Journal.find(params[:id])
    @accounts = Account.all(:order => "account_type, subject_num")
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/new
  # GET /journals/new.xml
  def new
    @journal = Journal.new
    @accounts = Account.all(:order => "account_type, subject_num")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/1/edit
  def edit
    @journal = Journal.find(params[:id])
    @accounts = Account.all(:order => "account_type, subject_num")
  end

  # POST /journals
  # POST /journals.xml
  def create
    @journal = Journal.new(fabricate_journal_params( params[:journal] ))
    
    respond_to do |format|
      if @journal.save
        flash[:notice] = '成功新增傳票'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @journal, :status => :created, :location => @journal }
      else
        @accounts = Account.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    @journal = Journal.find(params[:id])
    
    respond_to do |format|
      if @journal.update_attributes(fabricate_journal_params( params[:journal] ))
        flash[:notice] = '成功更新傳票'
        #format.html { redirect_to :action => 'index' }
        format.html { redirect_to(@journal) }
        format.xml  { head :ok }
      else
        @accounts = Account.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    @journal = Journal.find(params[:id])
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.xml  { head :ok }
    end
  end
  
protected 
  
  # [kuan] until i find a better way... this is such a hack. NO GOOD.
  def fabricate_journal_params(params)
    total_debit  = 0
    total_credit = 0
    
    params[:entries_attributes].keys.each do |k|
      params[:entries_attributes][k]['entry_date(1i)']  = params['entry_date(1i)']
      params[:entries_attributes][k]['entry_date(2i)']  = params['entry_date(2i)']
      params[:entries_attributes][k]['entry_date(3i)']  = params['entry_date(3i)']
      params[:entries_attributes][k][:description]      = params[:title]
      total_debit  += Float(params[:entries_attributes][k][:debit])
      total_credit += Float(params[:entries_attributes][k][:credit])
    end
    
    params[:total_debit]  = total_debit.to_s;
    params[:total_credit] = total_credit.to_s;
    
    return params
  end
  

end
