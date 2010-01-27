class InstrumentsController < ApplicationController

  def index
    @instruments = Instrument.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instruments }
    end
  end

end
