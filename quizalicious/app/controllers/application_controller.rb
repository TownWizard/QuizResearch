# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_p3p
#  before_filter :ensure_authenticated_to_facebook
  
  def current_user
    unless current_facebook_user.nil?
      @current_user ||= User.for_facebook_id(current_facebook_user.id)
    end
  end

  #each time a user visits apps.facebook.com/spriteclub, we will refresh their access token
  #1 - check for a user_id from the signed_request
  #2 - check the session for an active user
  #3 - nothing worked.  redirect to the auth page.
  def ensure_authenticated_to_facebook
    if params[:error].eql?("access_denied") && params[:error_reason].eql?("user_denied")
      
    else
      if current_facebook_user == nil
        logger.info "no auth token, session, or cookie found."
        top_redirect_to auth_url
      else
        current_user.update_fb_user_detail(facebook_params[:oauth_token], facebook_params[:expires], current_facebook_user.fetch)
        quiz_instance = QuizInstance.find_by_quiz_instance_uuid(session[:quiz_instance_uuid])
        quiz_instance.update_attributes(:user_id => current_user.id)
        facebook_instance = FacebookInstance.find_by_id(session[:facebook_instance_id])
        facebook_instance.update_attributes(:user_id => current_user.id) unless facebook_instance.nil?
      end
    end
  end
  
  def fb_create_user_and_client(token, expires, userid)
    #  logger.info "-----------------Facebbok User--------- #{current_facebook_user.fetch}"
    client  = Mogli::Client.new(token, expires.to_i)
    user    = Mogli::User.new(:id => userid)
    @user   = User.for(token, expires, user.fetch)
    fb_sign_in_user_and_client(user,client)
  end

  #creates the oauth url for the user to request authorize and authenticate to spriteclub
  # more details on the scope and display options can be found here:
  # http://developers.facebook.com/docs/authentication/
  def auth_url
    #    url = authenticator.authorize_url(:scope => 'email,user_birthday,user_likes,offline_access,photo_upload', :display => 'page')
    #    Permissions ,manage_pages,offline_access,publish_stream
    authenticator.authorize_url(:scope => 'email,user_birthday,user_likes', :display => 'page')
  end


  def authenticator
    # by redirecting back to HTTP_REFERER, we will go back to the the apps.facebook.com request!
    # if there is no referrer, send this request url as the callback url
#     redirect_url = (@_request.env["HTTP_REFERER"] != nil ?
#                    @_request.env["HTTP_REFERER"] :
#                    @_request.env["rack.url_scheme"] + "://" + @_request.env["HTTP_HOST"] + @_request.env["REQUEST_PATH"])
    redirect_url = "http://apps.facebook.com/" + ENV["fb_app_name"] + request.path
    @authenticator ||= Mogli::Authenticator.new(Facebooker2.app_id, Facebooker2.secret, redirect_url )
  end
  
  # Redirects the top window to the given url if the content is in an iframe, otherwise performs 
  # a normal redirect_to call. 
  def top_redirect_to(url)
    render :layout => false, :inline => '<html><head><script type="text/javascript">window.top.location.href = '+
      url.to_json+
      ';</script></head></html>'
  end
  
  #we need to set this p3p privacy policy header or facebook connect will never work on IE
  def set_p3p
    response.headers["P3P"]='CP="CAO PSA OUR"'
  end
  
end
