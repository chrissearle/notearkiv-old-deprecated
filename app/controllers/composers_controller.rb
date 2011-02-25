# coding: UTF-8

class ComposersController < ApplicationController
  filter_access_to :all

  def index
    @composers = Composer.find(:all).sort_by{|p| p.name.downcase}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @composers }
    end
  end

  def new
    @composer = Composer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @composer }
    end
  end

  def create
    @composer = Composer.new(params[:composer])

    respond_to do |format|
      if @composer.save
        flash[:notice] = 'Komponist opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @composer, :status => :created,
                      :location => @composer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @composer.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @composer = Composer.find(params[:id])
  end

  def update
    @composer = Composer.find(params[:id])

    respond_to do |format|
      @composer.name = params["composer"]["name"]

      if @composer.save
        flash[:notice] = 'Komponist oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @composer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @composer = Composer.find(params[:id])

    flash[:notice] = "Komponist #{@composer.name} slettet."

    @composer.destroy


    respond_to do |format|
      format.html { redirect_to(composers_url) }
      format.xml  { head :ok }
    end
  end

end
