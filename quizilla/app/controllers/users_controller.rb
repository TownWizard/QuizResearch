class UsersController < ApplicationController

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    @user = User.new( params[:user] )
    if @user.save
      flash[:notice] = "Account registered!"
      if cookies[ :lcqiid ] && cookies[ :lcqiid ] != ''
        redirect_to :controller => :assessments, :action => :get
      else
        redirect_to :controller => :assessments, :action => :index
      end
    else
      render :action => :new
    end
  end

#  def create
#    logout_keeping_session!
#    @user = User.new(params[:user])
#    @user.user_type_id = UserType.find(:first, :conditions => "name = 'User'").id || nil
#    @user.cobrand_id = session[ :cobrand_id ] || nil
#    success = @user && @user.save
#    if success && @user.errors.empty?
#      @user.activate!
#      logout_keeping_session!
#      user = User.authenticate( @user.login, @user.password )
#
#      if user
#        self.current_user = user
#
#        User.update( session[ :user_id ], :last_login => Time.now ).save
#        new_cookie_flag = (params[:remember_me] == "1")
#        handle_remember_cookie! new_cookie_flag
#
#        flash[:notice] = "Logged in successfully"
#        #redirect_to login_path( :loc => params[ :loc ] )
#        if cookies[ :lcqiid ] && cookies[ :lcqiid ] != ''
#          redirect_to :controller => :assessments, :action => :get
#        else
#          redirect_to :controller => :assessments, :action => :index
#        end
#      end
#
#      #flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code.  Note that you will not be able to login until you click the activate link in the email we send you."
#      flash[:notice] = "Thanks for signing up!  You should receive an email confirmation shortly."
#    else
#      flash[:notice]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin."
#      render :action => 'new'
#    end
#  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user_login = user.login #this can be removed if the DSF block goes, user.activate clears the object
      user.activate!
      #flash[:notice] = "Signup complete! Please log in to continue."
      #redirect_to login_path( :loc => params[ :loc ] )
      
      ## DSF -- uncomment the two lines above, and remove everything up until the "when params[:activation_code].blank?"
      ## line to disable automatic login post activation
      logout_keeping_session!
      user = User.find_by_login(user_login)
      
      self.current_user = user

      User.update( session[ :user_id ], :last_login => Time.now ).save
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag

      flash[:notice] = "Logged in successfully."
      if params[ :loc ] != nil
        redirect_to :controller => :assessments, :action => :get and return
      else
        redirect_to "/" and return
      end
      ## END DSF

    when params[:activation_code].blank?
      flash[:notice] = "The activation code was missing.  Please follow the URL from your email."
      redirect_to login_path( :loc => params[ :loc ] )
    else 
      flash[:notice]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to login_path( :loc => params[ :loc ] )
    end
  end
end
