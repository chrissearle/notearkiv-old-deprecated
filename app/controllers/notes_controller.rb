# coding: UTF-8

class NotesController < ApplicationController
  filter_access_to :all

  before_filter :get_note, :only => [:show, :edit, :update, :destroy]

  def index
    set_accept_header
    @notes = Note.ordered.preloaded

    prawnto :prawn => {:page_layout=>:landscape, :top_margin => 10, :bottom_margin => 10}, :inline => false,
            :filename => "Notearkiv_#{Date.today().strftime("%Y-%m-%d")}.pdf"

    respond_to do |format|
      format.html # index.html.erb
      format.txt { index_suggest_voices }
      format.pdf
      format.xls { index_excel }
    end
  end

  def import
  end

  def show
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(params[:note])

    if @note.save
      flash[:notice] = 'Note opprettet.'
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @note.update_attributes(params[:note])
      flash[:notice] = 'Note oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    flash[:notice] = "Note #{@note.title} slettet."

    @note.destroy

    redirect_to(notes_url)
  end

  private

  def index_excel
    excel = Note.excel

    send_file(excel.get_spreadsheet,
              :type => 'application/vnd.ms-excel',
              :disposition => 'attachment',
              :filename => excel.get_filename)
  end

  def index_suggest_voices
    send_data Note.suggest_voice(params[:q].downcase).join("\n"),
              :type => 'text/plain',
              :disposition => 'inline'
  end

  def get_note
    @note = Note.find(params[:id])
  end
end


