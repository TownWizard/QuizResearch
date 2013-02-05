class Authorization < ActiveRecord::Base
  belongs_to :survey_instance
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, si = nil)
#    user ||= User.create_from_hash(hash)
    Authorization.create(:survey_instance_id => si.id, :uid => hash['uid'], :provider => hash['provider'])
  end
end
