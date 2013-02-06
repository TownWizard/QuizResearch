class OrderMailer < ActionMailer::Base

  def checkout_completed(user)
    setup_email(user)
    @subject    += 'Your Order Has Been Placed'
    @body[:url]  = "http://healthplan.maxwelldaily.com"
  end
  
  def checkout_authorized(user)
    setup_email(user)
    @subject    += 'Your Order Has Been Processed'
    @body[:url]  = "http://healthplan.maxwelldaily.com"
  end

  def checkout_declined(user)
    setup_email(user)
    @subject    += 'There Was a Problem With Your Order'
    @body[:url]  = "http://healthplan.maxwelldaily.com"
  end

  def checkout_posted(user)
    setup_email(user)
    @subject    += 'Your Order Has Been Sent to OptumHealthAllies'
    @body[:url]  = "http://healthplan.maxwelldaily.com"
  end

  def checkout_shipped(user)
    setup_email(user)
    @subject    += 'Your Membership Information Has Been Shipped'
    @body[:url]  = "http://healthplan.maxwelldaily.com"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "\"MaxWellDaily.com\" <support@MaxWellDaily.com>"
      @subject     = "MaxWell Daily Healthplan Account - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
