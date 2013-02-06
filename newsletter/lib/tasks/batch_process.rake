task :batch_process => :environment do
  subscribers = Subscriber.find(:all, :joins => :newsletter_subscriptions, :conditions => ["subscribers.id=newsletter_subscriptions.subscriber_id AND newsletter_subscriptions.opt_in=true"])
  subscribers.each do |s|
    Notification.send_later(:deliver_subscribe_newsletter_email, s, Newsletter.first)
  end
end