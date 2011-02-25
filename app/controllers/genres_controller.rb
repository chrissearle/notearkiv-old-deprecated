# coding: UTF-8

class GenresController < ApplicationController
  filter_access_to :all

  before_filter :get_genre, :only => [:edit, :update, :destroy]

  def index
    @genres = Genre.find(:all).sort_by { |p| p.name.downcase }
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(params[:genre])

    if @genre.save
      flash[:notice] = 'Genre opprettet.'
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    @genre.name = params["genre"]["name"]

    if @genre.save
      flash[:notice] = 'Genre oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    flash[:notice] = "Genre #{@genre.name} slettet."

    @genre.destroy

    redirect_to(genres_url)
  end

  private

  def get_genre
    @genre = Genre.find(params[:id])
  end

end
