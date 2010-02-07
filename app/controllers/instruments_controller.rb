class InstrumentsController < ApplicationController
  def index
    @instruments = Instrument.find(:all).sort_by{|p| p.name.downcase}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instruments }
    end
  end

  def new
    @instrument = Instrument.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @instrument }
    end
  end

  def create
    @instrument = Instrument.new(params[:instrument])

    respond_to do |format|
      if @instrument.save
        flash[:notice] = 'Akkompagnement opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @instrument, :status => :created,
                      :location => @instrument }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @instrument.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @instrument = Instrument.find(params[:id])
  end

  def update
    @instrument = Instrument.find(params[:id])

    respond_to do |format|
      @instrument.name = params["instrument"]["name"]

      if @instrument.save
        flash[:notice] = 'Akkompagnement oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @instrument.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
