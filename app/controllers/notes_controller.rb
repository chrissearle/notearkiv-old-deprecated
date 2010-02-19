require 'excel/header_column'
require 'excel/note_sheet'

class NotesController < ApplicationController
  filter_access_to :all

  def index
    @notes = Note.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @notes }
    end
  end

  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @note }
    end
  end

  def new
    @note = Note.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @note }
    end
  end

  def create
    @note = Note.new(params[:note])

    respond_to do |format|
      if @note.save
        flash[:notice] = 'Note opprettet.'
        format.html { redirect_to :action => "index" }
        format.xml { render :xml => @note, :status => :created,
                            :location => @note }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @note.errors,
                            :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        flash[:notice] = 'Note oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  def voice
    data = ""

    # The following query goes thru to the database and needs to be specific for postgres - since production is postgres.
    Note.find(:all, :conditions => ["voice ilike ?", params[:q] + "%"], :select => 'DISTINCT voice' ).each do |voice|
      data = data + "#{voice.voice}\n"
    end

    send_data data, :type => 'text/plain'
  end


  def excel
    sheet_title = 'Notearkiv'

    spreadsheet = NoteSheet.new([HeaderColumn.new("SysID", 8),
                       HeaderColumn.new("ID", 8),
                       HeaderColumn.new("Tittel", 50),
                       HeaderColumn.new("Komponist", 35),
                       HeaderColumn.new("Genre", 35),
                       HeaderColumn.new("Epoke", 35),
                       HeaderColumn.new("Språk", 35),
                       HeaderColumn.new("Akkomp.", 35),
                       HeaderColumn.new("Original", 8),
                       HeaderColumn.new("Kopi", 8),
                       HeaderColumn.new("Instr.", 8),
                       HeaderColumn.new("Besetning", 15)],
                                Note.find(:all).sort_by{|p| p.title.downcase},
                                sheet_title,
                                lambda {|row, item|
                                  langs = item.languages.map{|lang| lang.name }

                                  row.push item.id
                                  row.push item.item
                                  row.push item.title
                                  row.push (item.composer ? item.composer.name : "")
                                  row.push (item.genre ? item.genre.name : "")
                                  row.push (item.period ? item.period.name : "")
                                  row.push langs.join(", ")
                                  row.push item.instrument
                                  row.push item.count_originals
                                  row.push item.count_copies
                                  row.push item.count_instrumental
                                  row.push item.voice
                                })

    send_file spreadsheet.get_spreadsheet,
              :filename => "#{sheet_title.downcase}.xls",
              :type => 'application/vnd.ms-excel',
              :disposition => 'attachment'
  end

end


