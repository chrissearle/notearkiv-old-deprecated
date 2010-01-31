class LanguagesController < ApplicationController

  def index
    @languages = Language.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @languages }
    end
  end

end
