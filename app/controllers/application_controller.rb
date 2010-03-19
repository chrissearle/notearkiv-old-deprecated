# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter { |c| Authorization.current_user = c.current_user }

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password


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
