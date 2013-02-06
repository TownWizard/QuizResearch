class QuizAnswer < ActiveRecord::Base
  belongs_to :quiz_question
  belongs_to :answer_response_type
  belongs_to :next_quiz_phase, :class_name => "QuizPhase"
  has_one :quiz_learning_blurb, :dependent => :destroy
  has_many :user_quiz_answers

  delegate :quiz_phase, :to => :quiz_question
  
  named_scope :active, :conditions => 'active = true'

  default_scope :order => :position

  acts_as_reportable

  after_validation :reset_size_fields

  def can_decide_next_phase?
    (quiz_phase.branch_question_id == quiz_question.id) && quiz_question.answer_display_type.display_type.eql?("RADIO")
  end

  # After updating +answer_response_type+ always, it checks which value is set.
  # Accordingly it reset other fields.
  # If it is set as +TEXT+, then +rows+ and +cols+ should be reset
  # If it is set as +TEXTAREA+, then +size+ and +maxlength+ should be reset
  # If it is another value, then all +rows+, +cols+, size and +maxlength+ should be reset
  def reset_size_fields
    # if question answer_display_type is set as +TEXT+ or +TEXTAREA+, then size fields are needed for display purpose
    # So don't reset it that time
    return if ['TEXT', 'TEXTAREA'].include?(AnswerDisplayType.find(self.quiz_question.answer_display_type_id).try(:display_type))
    # otherwise those should pass conditional test to reset
    response_type = AnswerResponseType.find(self.answer_response_type_id).response_type
    attr_list = if response_type.eql?("TEXT")
      ["rows", "cols"]
    elsif response_type.eql?("TEXTAREA")
      ["size", "maxlength"]
    else
      ["rows", "cols", "size", "maxlength"]
    end
    attr_list.flatten.each {|attr| self.send(:"#{attr}=", nil)}
  end

end
