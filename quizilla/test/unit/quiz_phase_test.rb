require 'test_helper'
require 'factory_girl'

class QuizPhaseTest < ActiveSupport::TestCase
  context "basic list behavior: all phases " do
    setup do
      3.times do
        QuizPhase.create( :name => Sham.label, :quiz_id => 1, :position => Sham.position )
      end
      @p1 = QuizPhase.all.first
      @p2 = QuizPhase.all.second
      @p3 = QuizPhase.all.third
    end

    should "be in list" do
      QuizPhase.all.each do |p|
        assert_equal( true, p.in_list? )
      end
    end

    should "return nil for previous item if first in list" do
      assert_nil( @p1.previous_phase )
    end

    should "return previous item in list" do
      assert_equal( @p1, @p2.previous_phase )
    end

    should "return next item in list" do
      assert_equal( @p2, @p3.previous_phase )
    end

    should "return nil for next item if last in list" do
      assert_nil @p3.next_phase
    end
    
  end
end
