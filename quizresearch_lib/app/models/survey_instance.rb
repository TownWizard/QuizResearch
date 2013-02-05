class SurveyInstance < ActiveRecord::Base
#  validates_uniqueness_of :uid, :scope => :provider
  has_many :authorizations, :dependent => :destroy
end
