class SubscriberJob < Struct.new(:subscriber, :newsletter)
  def perform
    current_newsletter_subscription = subscriber.subscription_in(newsletter)
    begin
        Notification.deliver_subscribe_newsletter_email(subscriber, newsletter)
        current_newsletter_subscription.update_attributes(:last_submitted => DateTime.now, :last_submitted_success => true)
      rescue => e
        current_newsletter_subscription.update_attributes(:last_submitted => DateTime.now, :last_submitted_success => false, :submit_error => e)
      end
    end 
end

#Delayed::Job.enqueue(SubscriberJob.new(Subscriber.find(:all)))
