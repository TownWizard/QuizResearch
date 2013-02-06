class AnswerDisplayType < ActiveRecord::Base
  has_many :quiz_questions

  acts_as_reportable
end
