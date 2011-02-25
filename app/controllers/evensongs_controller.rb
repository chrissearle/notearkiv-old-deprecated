# coding: UTF-8

class EvensongsController < ApplicationController
  filter_access_to :all

  def index
    set_accept_header
    @evensongs = Evensong.find_all_sorted

    prawnto :prawn => {:page_layout=>:landscape, :top_margin => 10, :bottom_margin => 10}, :inline => false,
            :filename => "Evensongarkiv_#{Date.today().strftime("%Y-%m-%d")}.pdf"

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @evensongs }
      format.pdf
      format.xls do
        excel = Evensong.excel

        send_file(excel.get_spreadsheet,
                  :type => 'application/vnd.ms-excel',
                  :disposition => 'attachment',
                  :filename => excel.get_filename)
      end
    end
  end

  def show
    @evensong = Evensong.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @evensong }
    end
  end

  def new
    @evensong = Evensong.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @evensong }
    end
  end

  def create
    @evensong = Evensong.new(params[:evensong])

    respond_to do |format|
      if @evensong.save
        flash[:notice] = 'Evensongnote opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml { render :xml => @evensong, :status => :created,
                            :location => @evensong }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @evensong.errors,
                            :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @evensong = Evensong.find(params[:id])
  end

  def update
    @evensong = Evensong.find(params[:id])

    respond_to do |format|
      if @evensong.update_attributes(params[:evensong])
        flash[:notice] = 'Evensongnote oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @evensong.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @evensong = Evensong.find(params[:id])

    flash[:notice] = "Evensongnote #{@evensong.title} slettet."

    @evensong.destroy

    respond_to do |format|
      format.html { redirect_to(evensongs_url) }
      format.xml { head :ok }
    end
  end
end

