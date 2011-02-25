# coding: UTF-8

class LanguagesController < ApplicationController
  filter_access_to :all

  before_filter :get_language, :only => [:edit, :update, :destroy]


  def index
    @languages = Language.find(:all).sort_by { |p| p.name.downcase }
  end

  def new
    @language = Language.new
  end

  def create
    @language = Language.new(params[:language])

    if @language.save
      flash[:notice] = 'Språk opprettet.'
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    @language.name = params["language"]["name"]

    if @language.save
      flash[:notice] = 'Språk oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @language = Language.find(params[:id])

    flash[:notice] = "Språk #{@language.name} slettet."

    @language.destroy

    redirect_to(languages_url)
  end

  private

  def get_language
    @language = Language.find(params[:id])
  end

end
