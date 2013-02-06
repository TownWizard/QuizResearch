require 'test_helper'

class SuggestMailerTest < ActionMailer::TestCase
  test "suggest_quiz" do
    @expected.subject = 'SuggestMailer#suggest_quiz'
    @expected.body    = read_fixture('suggest_quiz')
    @expected.date    = Time.now

    assert_equal @expected.encoded, SuggestMailer.create_suggest_quiz(@expected.date).encoded
  end

end
