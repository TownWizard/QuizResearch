class UserQuizAnswer < ActiveRecord::Base

  belongs_to :user
  belongs_to :quiz_answer
  belongs_to :quiz_instance

  acts_as_reportable
end
