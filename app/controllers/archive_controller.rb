class ArchiveController < ApplicationController
  def download
    prefix = params[:prefix]
    file = params[:file]

    ArchiveConnection connection = ArchiveConnection.new

    send_data(connection.download("#{prefix}/#{file}"), :filename => file, :type => connection.mimetype_for_path(file), :disposition => "inline" )
  end
end
