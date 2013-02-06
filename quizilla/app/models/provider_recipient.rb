class ProviderRecipient < ActiveRecord::Base

  belongs_to :provider, :class_name => "Partner", :foreign_key => :provider_id
  belongs_to :recipient, :class_name => "Partner", :foreign_key => :recipient_id

end
