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
    book = Spreadsheet::Workbook.new

    sheet = book.create_worksheet
    sheet.name = "Notearkiv"

    header = sheet.row(0)

    format = Spreadsheet::Format.new :weight => :bold,
                                     :align => :center

    header.default_format = format


    header.concat %w{ID Tittel Original Kopi Instr. Besetning}


    Note.find(:all).each do |note|
      row = sheet.row(sheet.last_row_index() + 1)

      row.push note.display_id
      row.push note.title
      row.push note.count_originals
      row.push note.count_copies
      row.push note.count_instrumental
      row.push note.voice
    end

    sheet.column(0).width = 8
    sheet.column(1).width = 50
    sheet.column(2).width = 8
    sheet.column(3).width = 8
    sheet.column(4).width = 8
    sheet.column(5).width = 15

    tmp_file = Tempfile.new('notearkiv')

    book.write(tmp_file)
    
    send_file tmp_file.path, :filename => 'notearkiv.xls', :type => 'application/vnd.ms-excel', :disposition => 'attachment'
  end

end
