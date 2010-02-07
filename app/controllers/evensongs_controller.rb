require 'spreadsheet'

class EvensongsController < ApplicationController

  def index
    @evensongs = Evensong.find(:all)

    respond_to do |format|
      format.html # index.html.erb
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

    @header_columns = [HeaderColumn.new("Tittel", 50),
                       HeaderColumn.new("Salme", 8)]
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

      row.push evensong.title
      row.push evensong.psalm
    end
  end

  def write_to_temporary_file(book)
    tmp_file = Tempfile.new('evensongarkiv')

    book.write(tmp_file)

    return tmp_file.path
  end

  def get_spreadsheet
    book = Spreadsheet::Workbook.new

    sheet = generate_sheet(book)

    generate_header_row(sheet)

    generate_rows(sheet)

    return write_to_temporary_file(book)
  end
end