require 'date'

require 'excel/header_column'
require 'excel/note_sheet'

require 'archive/archive'

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
        @evensong.upload

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

  def upload(file)
    if file instance_of? File
      if file.exists?
        
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
        @evensong.upload

        flash[:notice] = 'Evensong oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evensong.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @evensong = Evensong.find(params[:id])

    if (!(@evensong.url.nil? || @evensong.url == ""))
      archive = Archive.new :evensong_archive

      archive.remove_file_if_exists @evensong.id
    end

    flash[:notice] = "Evensong #{@evensong.title} slettet."

    @evensong.destroy

    respond_to do |format|
      format.html { redirect_to(evensongs_url) }
      format.xml  { head :ok }
    end
  end

  def excel
    sheet_title = 'Evensongarkiv'
    date_str = Date.today().strftime("%Y-%m-%d")

    spreadsheet = NoteSheet.new([HeaderColumn.new("SysID", 8),
                                 HeaderColumn.new("Tittel", 50),
                                 HeaderColumn.new("Salme", 8),
                                 HeaderColumn.new("Komponist", 50),
                                 HeaderColumn.new("Genre", 35)],
                                Evensong.find(:all).sort_by{|p| p.title.downcase},
                                sheet_title,
                                date_str,
                                lambda {|row, item|
                                  row.push item.id
                                  row.push item.title
                                  row.push item.psalm
                                  row.push (item.composer ? item.composer.name : "")
                                  row.push (item.genre ? item.genre.name : "")
                                })

    send_file spreadsheet.get_spreadsheet,
              :filename => "#{sheet_title.downcase}_#{date_str}.xls",
              :type => 'application/vnd.ms-excel',
              :disposition => 'attachment'
  end

end

