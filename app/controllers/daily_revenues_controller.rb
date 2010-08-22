class DailyRevenuesController < ApplicationController
  # GET /daily_revenues
  # GET /daily_revenues.xml
  def index
    @daily_revenues = DailyRevenue.all

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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @daily_revenue }
    end
  end

  # GET /daily_revenues/1/edit
  def edit
    @daily_revenue = DailyRevenue.find(params[:id])
  end

  # POST /daily_revenues
  # POST /daily_revenues.xml
  def create
    @daily_revenue = DailyRevenue.new(params[:daily_revenue])

    respond_to do |format|
      if @daily_revenue.save
        flash[:notice] = 'DailyRevenue was successfully created.'
        format.html { redirect_to(@daily_revenue) }
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
        format.html { redirect_to(@daily_revenue) }
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
