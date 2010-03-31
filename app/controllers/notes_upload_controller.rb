class NotesUploadController < ApplicationController
  filter_access_to :all

  def upload
  end

  def import
    if (params[:file])
      if (Note.import(params[:file]))
        flash[:notice] = 'Noter oppdatert.'
      else
        flash[:error] = 'Oppdatering av noter hadde problemmer. Sjekk opplastingsfilen'
      end
      redirect_to notes_path
    else
      flash[:notice] = 'Du må velge en fil'
      redirect_to notesupload_path
    end
  end

end
