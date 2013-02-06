#config/initializers/omniauth.rb
require 'openid/store/filesystem'

ActionController::Dispatcher.middleware.use OmniAuth::Builder do
  provider :twitter,  'zBayb8P2BaIO9Ywv252rVw', 'kgquz6eb2Kp98lqZNATmQB7zcMBwjVF3tQA2CDc'
  provider :facebook, '8d71450405f15a1c7a3247767c0b6dba', '3eed4b16ab4a8e11fab03b29cc595ec9'
#  provider :facebook, '8d71450405f15a1c7a3247767c0b6dba', '3eed4b16ab4a8e11fab03b29cc595ec9', :setup => true
#  provider :linked_in, 'KEY', 'SECRET'
#  provider :open_id,  OpenID::Store::Filesystem.new('/tmp')
end
# you will be able to access the above providers by the following url
# /auth/providername for example /auth/twitter /auth/facebook

ActionController::Dispatcher.middleware do
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "google",  :identifier => "https://www.google.com/accounts/o8/id"
  #use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "yahoo",   :identifier => "https://me.yahoo.com"
  #use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "aol",     :identifier => "https://openid.aol.com"
  #use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => "myspace", :identifier => "http://myspace.com"
end
# you won't be able to access the openid urls like /auth/google
# you will be able to access them through
# /auth/open_id?openid_url=https://www.google.com/accounts/o8/id
# /auth/open_id?openid_url=https://me.yahoo.com
