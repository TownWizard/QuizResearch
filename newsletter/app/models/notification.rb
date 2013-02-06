class Notification < ActionMailer::Base

  def subscribe_newsletter_email(subscriber, newsletter)
    recipients subscriber.email
#    bcc        ["bcc@example.com", "Order Watcher <watcher@example.com>"]
    from       "system@example.com"
    subject    "Trend Report - Let Pops of Color Brighten Up Your Spring Wardrobe"
    sent_on    Date.today
    @host =   "localhost:3000"
    

    part :content_type => 'multipart/alternative' do |copy|
      copy.part :content_type => 'text/html' do |html|
        html.body = render( :file => "subscribe_newsletter_email.html.erb",
                            :body => { :subscriber => subscriber, :newsletter => newsletter } )
      end
    end
   
    attachment "application/pdf" do |a|
        a.body = File.read("public/newsletters/#{newsletter.title}/#{newsletter.active_newsletter.file_name}")
        a.filename = newsletter.active_newsletter.file_name
      end
  end

end
