class QuizPhase < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :branch_question, :class_name => "QuizQuestion"
  has_many :quiz_questions, :dependent => :destroy
#  acts_as_list :scope => :quiz

#  acts_as_reportable

  named_scope( :specific,
    lambda { |qid,step| { :include =>
          [ :quiz_questions => :quiz_answers ],
            :conditions => [ 'quiz_id = ? AND position = ?', qid, step ] } } )

  named_scope :ordered, :order => :position

  named_scope :excluding, lambda {|quiz_phase_id| {:conditions => ['id!=?', quiz_phase_id]}}

  named_scope :next_to, lambda {|position| {:conditions => ["position > ?", position]}}

  default_scope :conditions => [ 'active = ?', true ], :order => :position

  before_save :reset_branching_when_changed

  def siblings
    quiz.quiz_phases.excluding(self.id)
  end

  def next_siblings
    quiz.quiz_phases.next_to(self.position)
  end

  def next_phase
    if in_list? && !last?
      lower_item
    end
  end

  def previous_phase
    if in_list? && !first?
      higher_item
    end
  end

  # It resets +next_quiz_phase_id+ from each +quiz_answers+ records when parent phase's +branch_question_id+ is changed
  def reset_branching_when_changed
    if self.branch_question_id_changed?
      old_branch_question = QuizQuestion.find(self.branch_question_id_was)
      old_branch_question.quiz_answers.each do |answer|
        answer.update_attributes(:next_quiz_phase_id => nil)
      end
    end
  rescue Exception => exc
    puts "Error in resetting next_quiz_phase---> #{exc}"
    return true
  end

end
