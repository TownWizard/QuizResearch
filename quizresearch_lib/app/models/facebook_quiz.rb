class FacebookQuiz < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :partner_site
end
