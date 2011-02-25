# coding: UTF-8

class EvensongsController < ApplicationController
  filter_access_to :all

  before_filter :get_evensong, :only => [:show, :edit, :update, :destroy]

  def index
    set_accept_header
    @evensongs = Evensong.ordered.preloaded

    prawnto :prawn => {:page_layout=>:landscape, :top_margin => 10, :bottom_margin => 10}, :inline => false,
            :filename => "Evensongarkiv_#{Date.today().strftime("%Y-%m-%d")}.pdf"

    respond_to do |format|
      format.html # index.html.erb
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
  end

  def new
    @evensong = Evensong.new
  end

  def create
    @evensong = Evensong.new(params[:evensong])

    if @evensong.save
      flash[:notice] = 'Evensongnote opprettet.'
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @evensong.update_attributes(params[:evensong])
      flash[:notice] = 'Evensongnote oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    flash[:notice] = "Evensongnote #{@evensong.title} slettet."

    @evensong.destroy

    redirect_to(evensongs_url)
  end

  private

  def get_evensong
    @evensong = Evensong.find(params[:id])
  end
end

