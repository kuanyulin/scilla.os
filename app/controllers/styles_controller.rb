class StylesController < ApplicationController
  # GET /styles
  # GET /styles.xml
  def index
    @styles = Style.all(:order => 'vendor_id')
    @vendors = Vendor.all.map {|v| [v.id, v.name] }
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @styles }
    end
  end

  # GET /styles/1
  # GET /styles/1.xml
  def show
    @style = Style.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @style }
    end
  end

  # GET /styles/new
  # GET /styles/new.xml
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

  # GET /styles/1/edit
  def edit
    @style = Style.find(params[:id])
    @vendors = Vendor.all 
    @categories = Category.all
    @sizes = Size.all
  end

  # POST /styles
  # POST /styles.xml
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

  # PUT /styles/1
  # PUT /styles/1.xml
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

  # DELETE /styles/1
  # DELETE /styles/1.xml
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
