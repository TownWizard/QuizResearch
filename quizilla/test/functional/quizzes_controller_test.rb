require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  
  context "GET /quizzes/get should assign quiz " do
    setup do
      set_quiz_mocks
      q = Factory( :quiz )
      
      #debugger
      get :show, :id => q.id
    end
    
    should_assign_to :quiz
  end

end
