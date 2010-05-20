class ArchiveController < ApplicationController
  filter_access_to :all

  def download
    prefix = params[:prefix]
    type = params[:type]
    file = params[:file]
    ext = params[:format]

    connection = ArchiveConnection.new

    send_data(connection.download("#{prefix}/#{type}/#{file}.#{ext}"),
              :filename => "#{file}.#{ext}",
              :type => connection.mimetype_for_path(ext),
              :disposition => connection.disposition_for_path(ext) )
  end
end
