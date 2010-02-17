require 'spreadsheet'

class EvensongsController < ApplicationController

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
    spreadsheet = EvensongSpreadsheet.new(Evensong.find(:all))


    send_file spreadsheet.get_spreadsheet, :filename => 'evensongarkiv.xls', :type => 'application/vnd.ms-excel', :disposition => 'attachment'
  end

end

class HeaderColumn
  attr_reader :title, :width

  def initialize(title, width)
    @title = title
    @width = width
  end
end

class EvensongSpreadsheet

  def initialize(evensongs)
    @evensongs = evensongs

    @header_format = Spreadsheet::Format.new :weight => :bold,
                                             :align => :center

    @header_columns = [HeaderColumn.new("SysID", 8),
                       HeaderColumn.new("Tittel", 50),
                       HeaderColumn.new("Salme", 8),
                       HeaderColumn.new("Komponist", 50)]
  end

  def generate_sheet(book)
    sheet = book.create_worksheet
    sheet.name = "Evensongarkiv"

    return sheet
  end

  def generate_header_row(sheet)
    header = sheet.row(0)

    header.default_format = @header_format

    col = 0

    @header_columns.each do |column|
      header.push column.title

      sheet.column(col).width = column.width

      col += 1
    end
  end

  def generate_rows(sheet)
    @evensongs.each do |evensong|
      row = sheet.row(sheet.last_row_index() + 1)

      row.push evensong.id
      row.push evensong.title
      row.push evensong.psalm
      row.push get_name_if_exists evensong.composer
    end
  end

  def write_to_temporary_file(book)
    tmp_file = Tempfile.new('evensongarkiv')

    book.write(tmp_file)

    return tmp_file.path
  end

  def get_name_if_exists(object)
    if (object)
      return object.name
    else
      return ""
    end
  end

  def get_spreadsheet
    book = Spreadsheet::Workbook.new

    sheet = generate_sheet(book)

    generate_header_row(sheet)

    generate_rows(sheet)

    return write_to_temporary_file(book)
  end
end