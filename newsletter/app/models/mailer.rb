class Mailer < ActionMailer::Base
  

  def invitation(invitation, newsletter = Newsletter.first)
    subject    'Newsletter Invitation'
    recipients invitation.recipient_email
    from       "system@example.com"
    sent_on    Date.today

    part :content_type => 'multipart/alternative' do |copy|
      copy.part :content_type => 'text/html' do |html|
        html.body = render( :file => "invitation.html.erb",
                            :body => { :invitation => invitation, :newsletter => newsletter } )
      end
    end

#    invitation.update_attribute(:sent_at, Time.now)
  end

end
