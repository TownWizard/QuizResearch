class Newsletter < ActiveRecord::Base
  has_many :newsletter_subscriptions
  has_many :subscribers, :through => :newsletter_subscriptions

  has_one :active_newsletter
end
