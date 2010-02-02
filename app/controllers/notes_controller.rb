require 'spreadsheet'

class NotesController < ApplicationController

  def index
    @notes = Note.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  def excel
    spreadsheet = NoteSpreadsheet.new(Note.find(:all))


    send_file spreadsheet.get_spreadsheet, :filename => 'notearkiv.xls', :type => 'application/vnd.ms-excel', :disposition => 'attachment'
  end

end

class HeaderColumn
  attr_reader :title, :width

  def initialize(title, width)
    @title = title
    @width =width
  end
end

class NoteSpreadsheet

  def initialize(notes)
    @notes = notes

    @header_format = Spreadsheet::Format.new :weight => :bold,
                                             :align => :center

    @header_columns = [HeaderColumn.new("ID", 8),
                       HeaderColumn.new("Tittel", 50),
                       HeaderColumn.new("Original", 8),
                       HeaderColumn.new("Kopi", 8),
                       HeaderColumn.new("Instr.", 8),
                       HeaderColumn.new("Besetning", 15)]
  end

  def generate_sheet(book)
    sheet = book.create_worksheet
    sheet.name = "Notearkiv"

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
    @notes.each do |note|
      row = sheet.row(sheet.last_row_index() + 1)

      row.push note.display_id
      row.push note.title
      row.push note.count_originals
      row.push note.count_copies
      row.push note.count_instrumental
      row.push note.voice
    end
  end

  def write_to_temporary_file(book)
    tmp_file = Tempfile.new('notearkiv')

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