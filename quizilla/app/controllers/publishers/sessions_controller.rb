class Publishers::SessionsController < Publishers::BaseController
  
  layout 'publishers'
  
  skip_before_filter :require_user, :only => [ :new, :create ]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    
    if @user_session.save

#      if current_user.has_role?( 'admin' )
#        flash[:notice] = "Login successful!"
#        redirect_to '/publishers' and return
#      elsif current_user.has_role?( 'partner_admin' )
#        flash[:notice] = "Login successful!"
#        redirect_to( '/publishers' ) and return
#      elsif current_user.has_role?( 'partner_report_viewer' )
        flash[:notice] = "Login successful."
        redirect_to( '/publishers/index' ) and return
#      else
#        flash[:notice] = "You are not authorized to access the Admin Tools."
#      end
    else
      flash[:notice] = "Your username or password do not match what we have on file.  Access Denied."
      render :action => :new
    end
 
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to '/publishers'
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:notice] = "We could not log you in with the credentials supplied.  Perhaps you mistyped them, or you have not yet activated your account by verifying your email address?"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
