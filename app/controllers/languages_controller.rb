class LanguagesController < ApplicationController
  def index
    @languages = Language.find(:all).sort_by{|p| p.name.downcase}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @languages }
    end
  end

  def new
    @language = Language.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @language }
    end
  end

  def create
    @language = Language.new(params[:language])

    respond_to do |format|
      if @language.save
        flash[:notice] = 'Språk opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @language, :status => :created,
                      :location => @language }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @language.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @language = Language.find(params[:id])
  end

  def update
    @language = Language.find(params[:id])

    respond_to do |format|
      @language.name = params["language"]["name"]

      if @language.save
        flash[:notice] = 'Språk oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @language.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
