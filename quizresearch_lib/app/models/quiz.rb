class Quiz < ActiveRecord::Base
  unloadable
  belongs_to :quiz_category
  belongs_to    :partner
  has_many :shared_quizzes
  has_many :facebook_quizzes
  has_many :partner_sites, :through => :shared_quizzes
  has_many :widgets

  has_many :quiz_lead_answers
  has_many :quiz_phases, :dependent => :destroy
  has_one :lead_phase, :class_name => 'QuizPhase', :conditions => { :position => 0 }
  has_many :quiz_recommendations, :dependent => :destroy
  has_many :surveys

  def questions_for_phase( phase_id )
    QuizQuestion.find( :all, :conditions => [ 'quiz_phase_id = ?', phase_id ] )
  end

  def total_quiz_questions
    total_questions = 0
    self.quiz_phases.each do |qp|
      total_questions += qp.quiz_questions.count
    end
    total_questions
  end

  def shared_with_partner_site?(partner_site)
    partner_sites.include?(partner_site)
  end

end
