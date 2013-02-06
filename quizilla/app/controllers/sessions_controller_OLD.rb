# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController


  # render new.rhtml
  def new
    # Get the user's score for any newly completed quizzes
    if cookies[ :qiid ]
      if cookies[ :lqiid ]
        @quiz_instance = QuizInstance.find( :first, :conditions => [ 'quiz_instance_uuid = ?', cookies[ :lcqiid ] ] )
        @score = 0
        @quiz_instance.user_quiz_answers.each do |answer|
         @score += answer.quiz_answer.value
        end
      end
    end
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])

    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      
      User.update( session[ :user_id ], :last_login => Time.now ).save
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      
      flash[:notice] = "Logged in successfully"
      #if params[ :loc ] != nil
      #  if cookies[ :lcqiid ] and cookies[ :lcqiid ] != ''
      #    redirect_to :controller => params[ :loc ], :action => :get and return
      #  else
      #    redirect_to :controller => params[ :loc ], :action => :index and return
      #  end
      #else
      #  redirect_to "/" and return
      #end
      redirect_back_or_default '/'
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_to login_path( :loc => params[ :loc ] ) and return
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:notice] = "We could not log you in with the credentials supplied.  Perhaps you mistyped them, or you have not yet activated your account by verifying your email address?"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
