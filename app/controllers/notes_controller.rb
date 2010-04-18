class NotesController < ApplicationController
  filter_access_to :all

  def index
    set_accept_header
    @notes = Note.find_all_sorted

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @notes }
      format.txt { send_data Note.suggest_voice(params[:q].downcase),
                             :type => 'text/plain',
                             :disposition => 'inline' }
      format.pdf do
        pdf = Note.pdf

        send_data(pdf.get_document,
                  :type => 'application/pdf',
                  :disposition => 'attachment',
                  :filename => pdf.get_filename)
      end
      format.xls do
        excel = Note.excel

        send_file(excel.get_spreadsheet,
                  :type => 'application/vnd.ms-excel',
                  :disposition => 'attachment',
                  :filename => excel.get_filename)
      end
    end
  end

  def import
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @note }
    end
  end

  def create
    @note = Note.new(params[:note])

    @note.item = Note.next_item

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
end


