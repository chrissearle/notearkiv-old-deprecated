class PeriodsController < ApplicationController
  filter_access_to :all

  def index
    @periods = Period.find(:all).sort_by{|p| p.name.downcase}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @periods }
    end
  end

  def new
    @period = Period.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @period }
    end
  end

  def create
    @period = Period.new(params[:period])

    respond_to do |format|
      if @period.save
        flash[:notice] = 'Epoke opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @period, :status => :created,
                      :location => @period }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @period.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @period = Period.find(params[:id])
  end

  def update
    @period = Period.find(params[:id])

    respond_to do |format|
      @period.name = params["period"]["name"]

      if @period.save
        flash[:notice] = 'Epoke oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @period.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @period = Period.find(params[:id])

    flash[:notice] = "Epoke #{@period.name} slettet."

    @period.destroy


    respond_to do |format|
      format.html { redirect_to(periods_url) }
      format.xml  { head :ok }
    end
  end

end
