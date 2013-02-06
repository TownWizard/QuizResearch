# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  #include AuthenticatedSystem
  include PartnerSystem
  
  before_filter :load_partner_site, :initialize_error_hash
  filter_parameter_logging :password, :password_confirmation

  #layout :get_layout
  
  private

    def initialize_error_hash
      @errors = {}
    end

    def authenticate_request
      if request.remote_addr != "127.0.0.1"
        verify_authenticity_token
      end
    end
  
    def get_layout
      if params[:controller] == "surveys"
        "surveys"
      elsif params[:controller] == "healthplan"
        "healthplan"
      else
        @partner_site.key
      end
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to root_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def expose_authenticity_token
      @token = self.form_authenticity_token
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


      # so, we need to do some lookups based on quiz / quiz_phases in order to
    # figure out which actual phase record we're looking at.  I'm trying to set
    # as little data as possible in the cookie.  a real phase_id could be a
    # candiate for getting moved out to the client.  we'll see.

    def qiid_cookie_find qiid_value
      qiid_cookie_read.include? qiid_value
    end

    def qiid_cookie_read
      cookies[ :qiid ].to_s.split( ',' )
    end

    def qiid_cookie_write qiid_value
      cookies[ :qiid ] = qiid_cookie_read.push( qiid_value ).join( ',' ) unless qiid_cookie_read.include?( qiid_value )
    end

    def qiid_cookie_remove qiid_value
      c = qiid_cookie_read
      c.delete qiid_value
      cookies[ :qiid ] = c.join( ',' )
    end

    private
    def set_version_string
      @url_version_string = ''
      if params[ :version ]
        @url_version_string = "/v/#{params[ :version ]}"
      end
    end
end
