# coding: UTF-8

class PeriodsController < ApplicationController
  filter_access_to :all

  before_filter :get_period, :only => [:edit, :update, :destroy]

  def index
    @periods = Period.ordered.preloaded
  end

  def new
    @period = Period.new
  end

  def create
    @period = Period.new(params[:period])

    if @period.save
      flash[:notice] = 'Epoke opprettet.'
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    @period.name = params["period"]["name"]

    if @period.save
      flash[:notice] = 'Epoke oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    flash[:notice] = "Epoke #{@period.name} slettet."

    @period.destroy

    redirect_to(periods_url)
  end

  private

  def get_period
    @period = Period.find(params[:id])
  end

end
