class EvensongsUploadController < ApplicationController
  filter_access_to :all

  def upload
  end

  def import
    if (params[:file])
      begin
        if (Evensong.import(params[:file]))
          flash[:notice] = 'Evensongnoter oppdatert. Det er anbefalt å laste ned et nytt kopi av arkivet med en gang.'
        end
      rescue Exception => e
        flash[:error] = e.message
      end

      redirect_to evensongs_path
    else
      flash[:notice] = 'Du må velge en fil'
      redirect_to evensongsupload_path
    end
  end

end
