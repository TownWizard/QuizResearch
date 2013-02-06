class QuizCategory < ActiveRecord::Base
  has_many :quizzes
  has_many :partner_site_categories_quiz_categories
  has_many :partner_site_categories, :through => :partner_site_categories_quiz_categories
  
  #has_many :quiz_lead_questions
  
  named_scope :active, :conditions => "active = #{true}"

  def shared_with_partner_site_category?(partner_site_category)
    partner_site_categories.include?(partner_site_category)
  end

end
