class Partner < ActiveRecord::Base
  has_many :partner_sites
  has_many :provider_recipients
  has_many :recipients, :through => :provider_recipients
  has_many :widgets
  accepts_nested_attributes_for :partner_sites
  
  validates_presence_of     :name
  
  validates_length_of       :name,    :within => 3..255
end
