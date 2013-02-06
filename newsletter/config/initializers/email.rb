require 'tls_smtp'

ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address => 'smtp.gmail.com',
    :port => 25,
    :domain => 'gmail.com',
    :user_name => 'noreplypubunion',
    :password => 'pubunion',
    :authentication => :plain,
  }