class SuggestMailer < ActionMailer::Base
  

  def suggest_quiz( sent_at = Time.now )
    subject    'SuggestMailer#suggest_quiz'
    recipients 'gabriel.correa@gmail.com'
    sent_on    sent_at
    
    body       :greeting => 'Hi.  This is a test'
  end

end
