class NotesController < ApplicationController
  filter_access_to :all

  def index
    set_accept_header
    @notes = Note.find_all_sorted
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @notes }
      format.xls do
        excel = Note.excel

        send_file(excel.get_spreadsheet,
                  :type => 'application/vnd.ms-excel',
                  :disposition => 'attachment',
                  :filename => excel.get_filename)
      end
    end
  end

  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @note }
    end
  end

  def new
    @note = Note.new
    @note.item = Note.next_item

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @note }
    end
  end

  def create
    @note = Note.new(params[:note])

    respond_to do |format|
      if @note.save
        @note.upload

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
        @note.upload

        flash[:notice] = 'Note oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @note = Note.find(params[:id])

    flash[:notice] = "Note #{@note.title} slettet."

    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.xml  { head :ok }
    end
  end

  def voice
    data = ""

    search = params[:q].downcase

    notes = Note.find(:all, :select => 'DISTINCT voice')

    notes.each do |note|
      if note.voice.downcase.start_with? search
        data = data + "#{note.voice}\n"
      end
    end

    send_data data, :type => 'text/plain'
  end
end


