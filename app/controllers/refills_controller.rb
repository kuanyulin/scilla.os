class RefillsController < ApplicationController
  # GET /refills
  # GET /refills.xml
  def index
    @refills = Refill.all(:order => 'order_date DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @refills }
    end
  end

  # GET /refills/1
  # GET /refills/1.xml
  def show
    @refill = Refill.find(params[:id])
    @styles = Style.find_all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @refill }
    end
  end

  # GET /refills/new
  # GET /refills/new.xml
  def new
    @refill = Refill.new
    @styles = Style.find_all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @refill }
    end
  end

  def get_sizes
    unless params[:style_id].blank?
      @style = Style.find(params[:style_id])
      @sizes = @style.sizes;
      render :partial => 'size_quantity', :layout => false
    else
      render :nothing => true
    end
  end
  
  
  # GET /refills/1/edit
  def edit
    @refill = Refill.find(params[:id])
    @styles = Style.find_all
  end

  # POST /refills
  # POST /refills.xml
  def create
    @refill = Refill.new(params[:refill])
    @refill.pairs = create_refill_pairs(params[:style_size])

    respond_to do |format|
      if @refill.save
        flash[:notice] = 'Refill was successfully created.'
        format.html { redirect_to(@refill) }
        format.xml  { render :xml => @refill, :status => :created, :location => @refill }
      else
        @styles = Style.find_all
        format.html { render :action => "new" }
        format.xml  { render :xml => @refill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /refills/1
  # PUT /refills/1.xml
  def update
    @refill = Refill.find(params[:id])
    old_status = @refill.arrived

    respond_to do |format|
      if @refill.update_attributes(params[:refill])
        if old_status != @refill.arrived 
          update_pair_status(@refill.pairs, @refill.arrived)
        end
        
        flash[:notice] = 'Refill was successfully updated.'
        format.html { redirect_to(@refill) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @refill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def print_fax
    @refill = Refill.find(params[:id])
    @styles = Hash.new
    
    @refill.pairs.each do |pair|
      @styles[pair.style.name] = [ pair.style, Array.new(15, 0) ] unless @styles.has_key?(pair.style.name)
      @styles[pair.style.name][1][Integer((pair.size-33)*2)] += 1
    end
      
    render :layout => false
  end
  
  
  # DELETE /refills/1
  # DELETE /refills/1.xml
  def destroy
    @refill = Refill.find(params[:id])
    @refill.destroy

    respond_to do |format|
      format.html { redirect_to(refills_url) }
      format.xml  { head :ok }
    end
  end

  
  private
  
  def create_refill_pairs(params)
    pairs = Array.new
 
#    pairs[0] = Pair.new (:style_id => 4, :size => 35.0, :status => 0, :note => "")
    params.each do |style, sizes|
      sizes.each do |size, quantity|
        unless quantity.blank? 
          Integer(quantity).times { |i| pairs << Pair.new(:style_id => Integer(style),
                                                          :size => size.to_f, 
                                                          :status => 0, 
                                                          :note => "") }
        end
      end
    end
    
    return pairs
  end
  
  def update_pair_status(pairs, arrived)
#    logger.info("***** updating pairs from refill ....")
#    new_status = arrived ? Pair::ON_SALE : Pair::BACK_ORDER
    
    pairs.each do |pair|
      if arrived
        pair.status = Pair::ON_SALE if pair.status == Pair::BACK_ORDER
        pair.status = Pair::SOLD    if pair.status == Pair::BACK_ORDER_SOLD
        pair.save
      else
        pair.status = Pair::BACK_ORDER      if pair.status == Pair::ON_SALE
        pair.status = Pair::BACK_ORDER_SOLD if pair.status == Pair::SOLD
        pair.save
      end
    end
    
  end
  
  
end
