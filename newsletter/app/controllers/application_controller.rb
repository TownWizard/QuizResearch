# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def current_newsletter_site
    @newsletter = Newsletter.find_by_title(params[:newsletter]) || not_found
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def allow_admin_only?
    
  end

end
