require 'test_helper'
require 'factory_girl'
class QuizTest < ActiveSupport::TestCase
  context "quiz phases" do
    setup do
      set_quiz_mocks
      3.times do
        Factory :quiz_phase
      end
    end

    should "return in ascending order by default" do
      phases = QuizPhase.find :all
      assert_equal( true, phases[ 0 ].position == 1 && phases[ 1 ].position == 2 && phases[ 2 ].position == 3 )
    end
  end

end