class SessionCachesController < ApplicationController
  filter_access_to :all

  def authorize
    if params[:oauth_token] then
      dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
      dropbox_session.authorize(params)

      begin
        session_cache = SessionCache.find(1)
      rescue ActiveRecord::RecordNotFound
        session_cache = SessionCache.new
      end
      
      session_cache.serialized_session = dropbox_session.serialize

      session_cache.save

      flash[:notice] = "Dropbox sesjon oppdatert"

      redirect_to root_path
    else
      dropbox_session = Dropbox::Session.new(ENV['DROPBOX_CONSUMER_KEY'], ENV['DROPBOX_CONSUMER_SECRET'])
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to dropbox_session.authorize_url(:oauth_callback => authorize_url)
    end
  end
end
