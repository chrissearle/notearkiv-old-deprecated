# coding: UTF-8

class NotesUploadController < ApplicationController
  filter_access_to :all

  def upload
  end

  def import
    if (params[:file])
      begin
        if (Note.import(params[:file]))
          flash.now[:notice] = 'Noter oppdatert. Det er anbefalt å laste ned et nytt kopi av arkivet med en gang.'

          @logs = ImportLog.ordered
        end
      rescue Exception => e
        flash[:error] = e.message

        redirect_to notesupload_path
      end
    else
      flash[:notice] = 'Du må velge en fil'
      redirect_to notesupload_path
    end
  end

end
