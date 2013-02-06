require 'test_helper'
require 'factory_girl'
class QuizTest < ActiveSupport::TestCase
  context "does factory girl work" do

    setup do
      set_quiz_mocks
      @quiz = Factory :quiz
    end

    should "have a full fleshed out quiz" do
      assert_not_nil @quiz.name
    end

    context "check dependent associations" do
      should "have a frikkin quiz category" do
        assert_not_nil @quiz.quiz_category
      end

      should "have 3 frikkin quiz phases" do
        assert_not_nil @quiz.quiz_phases
        assert_equal 3, @quiz.quiz_phases.size
      end

      should "have some frikkin questions on the frikkin phases" do
        @quiz.quiz_phases.each do |phase|
          assert_equal( true, phase.quiz_questions.size > 0 )
        end
      end

      should "have some frikkin answers on the frikkin questions" do
        @quiz.quiz_phases.collect{ |p| p.quiz_questions }.flatten.each do |q|
          assert_equal( true, ( q.quiz_answers.size > 0 ) )
        end
      end

      should "have some frikkin blurbs on the frikkin answers" do
        @quiz.quiz_phases.collect{ |p| p.quiz_questions }.flatten.collect{ |q| q.quiz_answers.collect }.flatten.each do |answer|
          assert_not_nil answer.quiz_learning_blurb
        end
      end
    end

  end
end