class GenresController < ApplicationController
  def index
    @genres = Genre.find(:all).sort_by{|p| p.name.downcase}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genres }
    end
  end

  def new
    @genre = Genre.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @genre }
    end
  end

  def create
    @genre = Genre.new(params[:genre])

    respond_to do |format|
      if @genre.save
        flash[:notice] = 'Genre opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @genre, :status => :created,
                      :location => @genre }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @genre.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])

    respond_to do |format|
      @genre.name = params["genre"]["name"]

      if @genre.save
        flash[:notice] = 'Genre oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @genre.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
