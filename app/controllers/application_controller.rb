# coding: UTF-8

class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery

  helper :all

  before_filter { |c| Authorization.current_user = c.current_user }

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
end
