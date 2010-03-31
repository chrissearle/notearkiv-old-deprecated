class EvensongsUploadController < ApplicationController
  filter_access_to :all

  def upload
  end

  def import
    if (params[:file])
      if (Evensong.import(params[:file]))
        flash[:notice] = 'Evensongnoter oppdatert.'
      else
        flash[:error] = 'Oppdatering av evensongnoter hadde problemmer. Sjekk opplastingsfilen'
      end
      redirect_to evensongs_path
    else
      flash[:notice] = 'Du må velge en fil'
      redirect_to evensongsupload_path
    end
  end

end
