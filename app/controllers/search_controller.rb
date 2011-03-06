class SearchController < ApplicationController
  filter_access_to :all

  def search
    @nsearch = Note.search(params[:nsearch])
    @esearch = Evensong.search(params[:esearch])
  end

  def results
    @nsearch = Note.search(params[:nsearch])
    @esearch = Evensong.search(params[:esearch])

    if (params[:search])
      @notes = Note.simple_search(params[:search])
      @evensongs = Evensong.simple_search(params[:search])
    else
      if (params[:nsearch])
        @nsearch = Note.search(params[:nsearch])
        @notes = @nsearch.all
      end
      if (params[:esearch])
        @esearch = Evensong.search(params[:esearch])
        @evensongs = @esearch.all
      end
    end
  end
end
