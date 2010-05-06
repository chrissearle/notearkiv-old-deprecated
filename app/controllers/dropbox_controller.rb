class DropboxController < ApplicationController
  def authorize
    if params[:oauth_token] then
      dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
      dropbox_session.authorize(params)
      session[:dropbox_session] = dropbox_session.serialize # re-serialize the authenticated session

      redirect_to :action => 'upload'
    else
      dropbox_session = Dropbox::Session.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to dropbox_session.authorize_url(:oauth_callback => root_url)
    end
  end
end
