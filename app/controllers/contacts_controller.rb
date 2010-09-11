class ContactsController < ApplicationController
  #--------------------------------------------------
  #  index
  #--------------------------------------------------
  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  #--------------------------------------------------
  #  show
  #--------------------------------------------------
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  #--------------------------------------------------
  #  new
  #--------------------------------------------------
  def new
    if params[:customer_id].blank?
      flash[:notice] = '請從顧客資料頁新增通聯紀錄'
      redirect_to :controller => 'customers'
    else
      @customer = Customer.find(params[:customer_id])
    end
    
    @contact = Contact.new
    @contact.customer     = @customer
    @contact.contact_date = Date.today
   
    @user  = User.find(session[:user].id)
    @contact.contacted_by = @user
    
    @users = User.all(:order => 'name').map{|x| [x.name, x.id]}
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  #--------------------------------------------------
  #  edit
  #--------------------------------------------------
  def edit
    @contact = Contact.find(params[:id])
    @users = User.all(:order => 'name').map{|x| [x.name, x.id]}
  end

  #--------------------------------------------------
  #  create
  #--------------------------------------------------
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to :controller => 'customers', :action => 'show', :id => @contact.customer.id }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  update
  #--------------------------------------------------
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to :controller => 'customers', :action => 'show', :id => @contact.customer.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  destroy
  #--------------------------------------------------
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
end
