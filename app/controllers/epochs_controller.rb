class EpochsController < ApplicationController
  def index
    @epochs = Epoch.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @epochs }
    end
  end

  def new
    @epoch = Epoch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @epoch }
    end
  end

  def create
    @epoch = Epoch.new(params[:epoch])

    respond_to do |format|
      if @epoch.save
        flash[:notice] = 'Epoch was successfully created.'
        format.html { redirect_to(@epoch) }
        format.xml  { render :xml => @epoch, :status => :created,
                      :location => @epoch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @epoch.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
