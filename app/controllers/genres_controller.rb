class GenresController < ApplicationController

  def index
    @genres = Genre.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genres }
    end
  end

end
