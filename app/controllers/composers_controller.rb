class ComposersController < ApplicationController

  def index
    @composers = Composer.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @composers }
    end
  end

end
