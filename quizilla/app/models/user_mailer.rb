class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://www.MaxWellDaily.com/activate/#{user.activation_code}?loc=assessments"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://www.MaxWellDaily.com/"
    #@body[:url] = "Use this link to access your completed quizzes."
    #@body[:url]  += "http://www.MaxWellDaily.com/activate/#{user.activation_code}?loc=assessments"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "\"MaxWellDaily.com\" <support@MaxWellDaily.com>"
      @subject     = "MaxWell Daily Account Activation - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
