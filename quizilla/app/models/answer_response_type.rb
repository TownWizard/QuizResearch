class AnswerResponseType < ActiveRecord::Base
  has_many :quiz_answers

  acts_as_reportable
end
