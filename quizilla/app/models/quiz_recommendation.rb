class QuizRecommendation < ActiveRecord::Base
  belongs_to :quiz
  
  named_scope :for_score, lambda { |score| { :conditions => [ '? BETWEEN value_floor AND value_ceiling', score ] } }

end
