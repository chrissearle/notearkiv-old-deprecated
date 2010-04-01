class NotesUploadController < ApplicationController
  filter_access_to :all

  def upload
  end

  def import
    if (params[:file])
      begin
        if (Note.import(params[:file]))
          flash[:notice] = 'Noter oppdatert. Det er anbefalt å laste ned et nytt kopi av arkivet med en gang.'
        end
      rescue Exception => e
        flash[:error] = e.message
      end
      
      redirect_to notes_path
    else
      flash[:notice] = 'Du må velge en fil'
      redirect_to notesupload_path
    end
  end

end
