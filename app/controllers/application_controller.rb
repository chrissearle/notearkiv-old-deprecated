# coding: UTF-8

class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery

  helper :all

  before_filter { |c| Authorization.current_user = c.current_user }
  before_filter :set_side

  protected

  def permission_denied
    flash[:error] = "Beklager - du har ikke tilgang til dette."

    redirect_to login_path
  end

  def set_accept_header
    # We only care about browsers. IE7 & 8 set some stupid ACCEPT header. Force fix.
    accept = request.env["HTTP_ACCEPT"]

    request.env["HTTP_ACCEPT"] = "application/xml,application/xhtml+xml,text/html;q=0.9,#{accept}"
  end

  def set_side
    if session[:side].nil?
      session[:side] = 'top'
    end

    if !params[:side].nil?
      if (params[:side] == 'top' || params[:side] == 'right')
        session[:side] = params[:side]
      end
    end
  end

end
