class QuizQuestion < ActiveRecord::Base
  belongs_to :quiz_phase
  belongs_to :answer_display_type
  has_many :quiz_answers, :dependent => :destroy

  named_scope( :by_phase, lambda { |p| { :conditions => [ 'quiz_phase_id = ?', p ] } } )
  named_scope :active, :conditions => [ 'active = ?', true ]
  named_scope :having_display_type, lambda {|type| {:conditions => ["answer_display_type_id=?", AnswerDisplayType.find_by_display_type(type)]}}

  default_scope :order => :position

  acts_as_reportable

  def allowed_answer_display_types
    unless quiz_answers.length > 1
      AnswerDisplayType.all
    else
      AnswerDisplayType.all.reject { |type| type.display_type.eql?("TEXT") || type.display_type.eql?("TEXTAREA") }
    end
  end

  def free_text_display_type?
    ["TEXT", "TEXTAREA"].include?(answer_display_type.display_type)
  end
end
