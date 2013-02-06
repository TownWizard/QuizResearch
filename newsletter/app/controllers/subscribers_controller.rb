class SubscribersController < ApplicationController
  before_filter :current_newsletter_site

  def create
    @subscriber = Subscriber.find_by_email(params[:subscriber][:email])

    if @subscriber.blank?
      @subscriber = Subscriber.new(params[:subscriber])
      valid = @subscriber.save
    else
      @subscriber.update_attributes(params[:subscriber])
      valid = true
    end



    if valid
      # First find if user has subscribed to current newsletter or not
      current_newsletter_subscription = @subscriber.subscription_in(@newsletter)
      # If user has not subscribed yet, create new subscription
      if current_newsletter_subscription.nil?
        current_newsletter_subscription = @subscriber.newsletter_subscriptions.create(:newsletter => @newsletter, :opt_in => true)
        # Or reset his subscription to +true+ regardless he has opted-out before or whatever
      else
        current_newsletter_subscription.update_attributes(:opt_in => true, :retry_count => 3)
      end

      begin
        Notification.send_later(:deliver_subscribe_newsletter_email, @subscriber, @newsletter)
        current_newsletter_subscription.update_attributes(:last_submitted => DateTime.now, :last_submitted_success => true)
      rescue => e
        current_newsletter_subscription.update_attributes(:last_submitted => DateTime.now, :last_submitted_success => false, :submit_error => e)
      end
       redirect_to new_invitation_path(:id => @subscriber)
#      flash[:notice] = "Thank you! You have successfully subscribed to this newsletter. Now proceed with filling-up your personal information(optional)."
#      redirect_to edit_subscriber_url(:id => @subscriber)
    else
      render 'newsletters/show'
    end
  end

  def edit
    @subscriber = Subscriber.find(params[:id])
  end

  def update
    @subscriber = Subscriber.find(params[:id])

    if @subscriber.update_attributes(params[:subscriber])
      flash[:notice] = "Your personal information updated successfully."
      redirect_to newsletter_url
    else
      render :action => 'edit'
    end
  end

  def unsubscribe
     @subscriber = Subscriber.find_by_email(params[:email])
     @newsletter = Newsletter.find_by_title(params[:newsletter])
     @newsletter_subscription = NewsletterSubscription.find(:first, :conditions => ['subscriber_id=? AND newsletter_id=?', @subscriber.id, @newsletter.id])
     if @newsletter_subscription.update_attribute(:opt_in, false)
#       flash[:notice] = "Successfully Unsubscribe."
#       redirect_to root_path
     end
  end
end
