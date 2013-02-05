class Survey < ActiveRecord::Base
  unloadable
  belongs_to :survey_template
  belongs_to :partner_site
  belongs_to :quiz
  has_many :quiz_instances

  acts_as_reportable

  validates_presence_of :survey_display_instance, :survey_template_id, :quiz_id, :partner_site_id, :reward_interstitial, :reward_url

  validates_length_of :survey_display_instance, :minimum => 1

end
