# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include PartnerSystem
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  before_filter :load_partner_site, :initialize_error_hash

  private

  def initialize_error_hash
    @errors = {}
  end

  def authenticate_request
    if request.remote_addr != "127.0.0.1"
      verify_authenticity_token
    end
  end

  def load_user
    @user = current_user
    if @user == nil
      id = params[ :user_id ] || session[ :user_id ]
      if id
        @user = User.find :first, :conditions => [ 'id=?', id.to_i ]
      end
    end
    @user
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
end
