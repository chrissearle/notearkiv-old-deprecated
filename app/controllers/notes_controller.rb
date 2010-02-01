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
    sheet1 = book.create_worksheet
    sheet1.name = "Notearkiv"
    sheet1.row(0).concat %w{ID Tittel Original Kopi Instrumental Besetning}

    Note.find(:all).each do |note|
      row = sheet1.row(sheet1.last_row_index() + 1)

      row.push note.display_id
      row.push note.title
      row.push note.count_originals
      row.push note.count_copies
      row.push note.count_instrumental
      row.push note.voice
    end

    tmp_file = Tempfile.new('notearkiv')

    book.write(tmp_file)
    
    send_file tmp_file.path, :filename => 'notearkiv.xls', :type => 'application/vnd.ms-excel', :disposition => 'attachment'
  end

end
