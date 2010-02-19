require 'excel/header_column'
require 'excel/note_sheet'

class EvensongsController < ApplicationController
  filter_access_to :all

  def index
    @evensongs = Evensong.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evensongs }
    end
  end

  def mapping
    @evensongs = Evensong.find(:all)

    respond_to do |format|
      format.html # mapping.html.erb
      format.xml  { render :xml => @evensongs }
    end
  end

  def show
    @evensong = Evensong.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @evensong }
    end
  end

  def new
    @evensong = Evensong.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @evensong }
    end
  end

  def create
    @evensong = Evensong.new(params[:evensong])

    respond_to do |format|
      if @evensong.save
        flash[:notice] = 'Evensong opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @evensong, :status => :created,
                             :location => @evensong }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evensong.errors,
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
        flash[:notice] = 'Evensong oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evensong.errors, :status => :unprocessable_entity }
      end
    end
  end

  def excel
    sheet_title = 'Evensongarkiv'

    spreadsheet = NoteSheet.new([HeaderColumn.new("SysID", 8),
                                 HeaderColumn.new("Tittel", 50),
                                 HeaderColumn.new("Salme", 8),
                                 HeaderColumn.new("Komponist", 50),
                                 HeaderColumn.new("Genre", 35)],
                                Evensong.find(:all).sort_by{|p| p.title.downcase},
                                sheet_title,
                                lambda {|row, item|
                                  row.push item.id
                                  row.push item.title
                                  row.push item.psalm
                                  row.push (item.composer ? item.composer.name : "")
                                  row.push (item.genre ? item.genre.name : "")
                                })

    send_file spreadsheet.get_spreadsheet,
              :filename => "#{sheet_title.downcase}.xls",
              :type => 'application/vnd.ms-excel',
              :disposition => 'attachment'
  end

end

