class PairsController < ApplicationController
  
  #--------------------------------------------------
  #  index
  #--------------------------------------------------
  def index
   # @pairs = Pair.all(:order =>'style_id, size, status')
    #@styles = Style.all(:order => 'vendor_id, name')
    @styles = Style.find_all_by_name
    @categories = Category.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pairs }
    end
  end

  #--------------------------------------------------
  #  get_inventory (AJAX)
  #--------------------------------------------------
  def get_inventory
    unless params[:style_id].blank? or params[:style_id] == "-1"
      @style = Style.find(params[:style_id])
      if params[:show_sold] == 'false'
        @pairs = Pair.find(:all, 
                           :conditions => ["style_id = ? and status <> ? ", @style.id, Pair::SOLD], 
                           :order => 'size, status',
                           :include => [ :style, :refill, { :items => { :order => :customer } } ])
      else
        @pairs = Pair.find(:all, 
                           :conditions => ["style_id = ?", @style.id], 
                           :order => 'size, status',
                           :include => [ :style, :refill, { :items => { :order => :customer } } ] )
      end
      @stats = Hash.new
      @stats['total'] = @pairs.size
      @stats['num_sold'] = 0
      @stats['count_size'] = Hash.new
      @pairs.each do |p|
        if p.status == Pair::SOLD and not p.items.empty?
          @stats['num_sold'] += 1 
          if @stats['count_size'].has_key?(p.size)
            @stats['count_size'][p.size] += 1
          else
            @stats['count_size'][p.size] = 1
          end
        end
      end      
      render :partial => 'inventory', :layout => false
#    # we really shouldn't display ALL style inventory!! -kuan
    else
#      @pairs = Pair.all(:order =>'style_id, size, status')
      @pairs = Array.new
      render :partial => 'inventory', :layout => false
    end
  end
  
  #--------------------------------------------------
  #  get_inventory_by_category (AJAX)
  #--------------------------------------------------  
  def get_inventory_by_category
    unless params[:cat_id].blank? or params[:cat_id] == "-1"
      @cat = Category.find(params[:cat_id])
      @pairs = Array.new
      if params[:show_sold] == 'false'
        @cat.styles.each do |s|
          @pairs += Pair.find(:all, 
                              :conditions => ["style_id = ? and status <> ? ", s.id, Pair::SOLD], 
                              :order => 'size, status',
                              :include => [ :style, :refill, { :items => { :order => :customer } } ] )
        end
      else
        @cat.styles.each do |s|
          @pairs += Pair.find(:all, 
                              :conditions => ["style_id = ?", s.id], 
                              :order => 'size, status',
                              :include => [ :style, :refill, { :items => { :order => :customer } } ] )
        end        
      end
      render :partial => 'inventory', :layout => false
    else
      @pairs = Pair.all(:order =>'style_id, size, status')
      render :partial => 'inventory', :layout => false
    end
  end
  
  #--------------------------------------------------
  #  show
  #--------------------------------------------------
  def show
    @pair = Pair.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pair }
    end
  end

  #--------------------------------------------------
  #  new
  #--------------------------------------------------
  def new
    @pair = Pair.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pair }
    end
  end

  #--------------------------------------------------
  #  edit
  #--------------------------------------------------
  def edit
    @pair = Pair.find(params[:id])
  end

  #--------------------------------------------------
  #  create
  #--------------------------------------------------
  def create
    @pair = Pair.new(params[:pair])

    respond_to do |format|
      if @pair.save
        flash[:notice] = 'Pair was successfully created.'
        format.html { redirect_to(@pair) }
        format.xml  { render :xml => @pair, :status => :created, :location => @pair }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pair.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  update
  #--------------------------------------------------
  def update
    @pair = Pair.find(params[:id])

    respond_to do |format|
      if @pair.update_attributes(params[:pair])
        flash[:notice] = 'Pair was successfully updated.'
        if params[:return_to_url].blank?
          format.html { redirect_to(@pair) }
        else
          format.html { redirect_to params[:return_to_url] }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pair.errors, :status => :unprocessable_entity }
      end
    end
  end

  #--------------------------------------------------
  #  inventory_summary
  #--------------------------------------------------
  def inventory_summary
    pairs = Pair.find(:all, :conditions => ['status = ?', Pair::ON_SALE], :order => 'style_id, size')
    @style_list = Style.find(:all, :order => 'name')
    @styles = Hash.new
    @size_total = Array.new(7, 0)
    
    pairs.each do |pair|
      @styles[pair.style.name] = Array.new(7, 0) unless @styles.has_key?(pair.style.name)
      size_index = Integer(pair.size - 5)
      @styles[pair.style.name][size_index] += 1
      @styles[pair.style.name][6] += 1
      @size_total[size_index] += 1
      @size_total[6] += 1
    end
    
    render :layout => false
  end
  
  #--------------------------------------------------
  #  inventory_complete
  #--------------------------------------------------
  def inventory_complete
    @styles = Style.find(:all, :order => 'name')
    render :layout => false
  end
  
  #--------------------------------------------------
  #  problem_items_and_pairs
  #--------------------------------------------------
  def problem_items_and_pairs
    #@items_no_order = Item.find(:all, :conditions => { :order_id => nil }, :order => 'purchase_date')
    pairs = Pair.find(:all, :conditions => { :status => Pair::SOLD } )
    
    @duplicates = Array.new
    pairs.each do |pair|
      if pair.items.length > 1
        sold = 0
        pair.items.each do |item|
          sold += 1 if item.status == Item::ITEM_SOLD
        end
        @duplicates << pair if sold > 1
      end
    end
    logger.info( '-------- Found ' + @duplicates.length.to_s + ' duplicates')
  end
  
  #--------------------------------------------------
  #  destroy
  #--------------------------------------------------
  def destroy
    @pair = Pair.find(params[:id])
    @pair.destroy

    respond_to do |format|
      format.html { redirect_to(pairs_url) }
      format.xml  { head :ok }
    end
  end
  
  def statistics 
    @graph = open_flash_chart_object(600,300,"/pairs/graph_code")
  
  end
  
  def graph_code
    title = Title.new("MY TITLE")
    bar = BarGlass.new
    bar.set_values([1,2,3,4,5,6,7,8,9])
    chart = OpenFlashChart.new
    chart.set_title(title)
    chart.add_element(bar)
    render :text => chart.to_s  
  end
  
  
  def statistics2
    
    @styles = Style.all
    @stats = Hash.new
    
    @styles.each do |style|
      count = Pair.count(:conditions => ["style_id = ? and status = ?", style.id, Pair::SOLD, ])
      @stats[style.name] = count        
    end
    
  end
  
    
end
