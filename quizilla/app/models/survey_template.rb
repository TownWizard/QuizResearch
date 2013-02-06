class SurveyTemplate < ActiveRecord::Base
  has_many :surveys

  validates_presence_of :template_code

  validates_length_of :template_code, :minimum => 1

end
