# coding: UTF-8

class ComposersController < ApplicationController
  filter_access_to :all

  before_filter :get_composer, :only => [:edit, :update, :destroy]

  def index
    @composers = Composer.find(:all).sort_by { |p| p.name.downcase }
  end

  def new
    @composer = Composer.new
  end

  def create
    @composer = Composer.new(params[:composer])

    if @composer.save
      flash[:notice] = 'Komponist opprettet.'

      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    @composer.name = params["composer"]["name"]

    if @composer.save
      flash[:notice] = 'Komponist oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    flash[:notice] = "Komponist #{@composer.name} slettet."

    @composer.destroy

    redirect_to(composers_url)
  end

  private

  def get_composer
    @composer = Composer.find(params[:id])
  end

end
