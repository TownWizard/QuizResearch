class SessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      flash[:notice] = "login and / or password not recognized."
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to 'login'
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:notice] = "We could not log you in with the credentials supplied.  Perhaps you mistyped them, or you have not yet activated your account by verifying your email address?"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
