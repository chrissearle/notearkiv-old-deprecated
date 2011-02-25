# coding: UTF-8

class EvensongsUploadController < ApplicationController
  filter_access_to :all

  def upload
  end

  def import
    if (params[:file])
      begin
        if (Evensong.import(params[:file]))
          flash.now[:notice] = 'Evensongnoter oppdatert. Det er anbefalt å laste ned et nytt kopi av arkivet med en gang.'

          @logs = ImportLog.find(:all, :order => 'item ASC, created_at ASC')
        end
      rescue Exception => e
        flash[:error] = e.message
        redirect_to evensongsupload_path
      end
    else
      flash[:notice] = 'Du må velge en fil'
      redirect_to evensongsupload_path
    end
  end

end
