# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include PartnerSystem

  before_filter :load_partner_site, :initialize_error_hash
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  def initialize_error_hash
    @errors = {}
  end
end
