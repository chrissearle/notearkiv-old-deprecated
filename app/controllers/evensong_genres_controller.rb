class EvensongGenresController < ApplicationController
  def index
    @evensong_genres = EvensongGenre.find(:all).sort_by{|p| p.name.downcase}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evensong_genres }
    end
  end

  def new
    @evensong_genre = EvensongGenre.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @evensong_genre }
    end
  end

  def create
    @evensong_genre = EvensongGenre.new(params[:evensong_genre])

    respond_to do |format|
      if @evensong_genre.save
        flash[:notice] = 'Evensong Genre opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @evensong_genre, :status => :created,
                      :location => @evensong_genre }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evensong_genre.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @evensong_genre = EvensongGenre.find(params[:id])
  end

  def update
    @evensong_genre = EvensongGenre.find(params[:id])

    respond_to do |format|
      @evensong_genre.name = params["evensong_genre"]["name"]

      if @evensong_genre.save
        flash[:notice] = 'Evensong Genre oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evensong_genre.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
