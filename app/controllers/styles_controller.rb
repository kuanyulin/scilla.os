class StylesController < ApplicationController
  #--------------------------------------------------
  #  index
  #--------------------------------------------------
  def index
    @styles = Style.all(:order => 'vendor_id, name')
    @vendors = Vendor.all.map {|v| [v.id, v.name] }
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @styles }
    end
  end

  #--------------------------------------------------
  #  show
  #--------------------------------------------------
  def show
    @style = Style.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @style }
    end
  end

  #--------------------------------------------------
  #  new
  #--------------------------------------------------
  def new
    @style = Style.new
    @vendors = Vendor.all 
    @categories = Category.all
    @sizes = Size.all
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @style }
    end
  end

  #--------------------------------------------------
  #  edit
  #--------------------------------------------------
  def edit
    @style = Style.find(params[:id])
    @vendors = Vendor.all 
    @categories = Category.all
    @sizes = Size.all
  end

  #--------------------------------------------------
  #  create
  #--------------------------------------------------
  def create
    @style = Style.new(params[:style])

    respond_to do |format|
      if @style.save
        flash[:notice] = '款式新增成功'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @style, :status => :created, :location => @style }
      else
        @vendors = Vendor.all 
        @categories = Category.all
        @sizes = Size.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @style.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  update
  #--------------------------------------------------
  def update
    @style = Style.find(params[:id])

    respond_to do |format|
      if @style.update_attributes(params[:style])
        flash[:notice] = '款式更新成功'
        format.html { redirect_to(@style) }
        format.xml  { head :ok }
      else
        @vendors = Vendor.all 
        @categories = Category.all
        @sizes = Size.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @style.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  destroy
  #--------------------------------------------------
  def destroy
    @style = Style.find(params[:id])
    @style.destroy

    respond_to do |format|
      format.html { redirect_to(styles_url) }
      format.xml  { head :ok }
    end
  end
  
protected
  
    def update_categories( params )
      
      return true
    end
 
end
