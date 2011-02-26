class SearchController < ApplicationController
  filter_access_to :all

  def search
  end

  def results
    @notes = Note.search(params[:search])
    @evensongs = Evensong.search(params[:search])
  end

end
