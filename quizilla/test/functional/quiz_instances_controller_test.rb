require 'test_helper'

class QuizInstancesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  context "newly created quiz instance" do
    setup do
      post :create, :qid => 1
      @quiz_instance = QuizInstance.first( :conditions => 'quiz_id = 1' )
    end

    should "work" do
      assert_response 303
      assert_redirected_to "/quizzes/open/#{@quiz_instance.quiz_instance_uuid}"
    end

    context "without user " do
      should "have quiz_instance_uuid" do
        assert_not_nil( @quiz_instance.quiz_instance_uuid )
      end

      should "have quiz id equal to 1" do
        assert_equal( 1, @quiz_instance.quiz_id )
      end

      should "NOT have user id" do
        assert_nil( @quiz_instance.user_id )
      end

      should "not be completed" do
        assert_equal( false, @quiz_instance.completed )
      end
    end
  end

  context "newly created quiz instance with user" do
    setup do
      Factory :user
      @user = User.find :first
      post :create, :qid => 1, :user_id => @user.id, :label => self.name
      @quiz_instance = QuizInstance.find( :first, :conditions => "quiz_id = 1 AND user_id = #{@user.id}" )
    end

    should "work" do
      assert_response 303
      assert_redirected_to "/quizzes/open/#{@quiz_instance.quiz_instance_uuid}"
    end

    context "with user" do
      
      should_assign_to :user
      
      should "have quiz_instance_uuid" do
        assert_not_nil( @quiz_instance.quiz_instance_uuid )
      end

      should "have quiz id" do
        assert_equal( 1, @quiz_instance.quiz_id )
      end

      should "have user id" do
        assert_equal( @user.id, @quiz_instance.user_id )
      end

      should "not be completed" do
        assert_equal( false, @quiz_instance.completed )
      end
    end

  end

  context "POST to create without uuid" do
    setup  do
      post :create
    end

    should "fail with response code 400" do
      assert_response 400
    end
  end

  context "GET to quiz_instances/index with user" do
    setup do
      set_quiz_mocks
      quiz = Factory( :quiz )
      @user = Factory( :user )
      3.times do 
        QuizInstance.new_quiz_instance( @user, quiz.id )
      end
      
      get :index, :user_id => @user.id
    end

    should "return list of quiz instances for supplied user" do
      assert_not_nil( assigns( :quiz_instances ) )
      assert_equal( true, assigns( :quiz_instances ).size > 0 )
      assigns( :quiz_instances ).each do |i|
        assert_equal( @user.id, i.user_id )
      end
    end
  end

  context "GET to quiz_instances/index without user" do
    setup do
      get :index
    end

    should "FAIL with status code 400" do
      assert_response 400
    end
  end

  context "POST to quiz_instance/submit_answers" do
    context " bad requests " do
      setup do
        set_quiz_mocks
      end

      context "missing " do
        should " qiid should fail" do
          post :submit_answers, :ppos => 1
          assert_response 400
        end

        should "phase_id should fail" do
          post :submit_answers, :qiid => ''
          assert_response 400
        end

        should "answers should fail" do
          post :submit_answers, :qiid => '', :ppos => 1
          assert_response 400
        end
      end

      context " with enough parameters " do
        should "fail without enough answers" do
          quiz = Factory :quiz
          @instance = QuizInstance.new_quiz_instance nil, quiz.id

          post :submit_answers, :qiid => @instance.quiz_instance_uuid, :ppos => 1, :questions => { "1" => "2", "2" => "3" }
          assert_response 400
        end

        should "fail with invalid submitted questions" do
          quiz = Factory :quiz
          @instance = QuizInstance.new_quiz_instance nil, quiz.id
          post :submit_answers, :qiid => @instance.quiz_instance_uuid, :ppos => 1, :questions => { "10" => "42", "54" => "11" , "11" => "54" }
          assert_response 400
          assert_equal( @response.body, "Incorrect questions submitted for this quiz page" )
        end

        should "fail with invalid answers" do
          quiz = Factory :quiz
          @instance = QuizInstance.new_quiz_instance nil, quiz.id
          post :submit_answers, :qiid => @instance.quiz_instance_uuid, :ppos => 1, 
            :questions => { "#{quiz.quiz_phases[0].quiz_questions[0].id}" => "42", "#{quiz.quiz_phases[0].quiz_questions[1].id}" => "11" , "#{quiz.quiz_phases[0].quiz_questions[2].id}" => "54" }
          assert_response 400
          assert_equal( @response.body, "Incorrect answers submitted for one or more questions." )
        end
      end
    end

    context "valid requests" do
      setup do
        set_quiz_mocks
        @quiz = Factory :quiz
        @instance = QuizInstance.new_quiz_instance nil, @quiz.id
      end
      
      context "on POST to submit_answers first phase" do
        setup do
          post(
            :submit_answers,
            :qiid => @instance.quiz_instance_uuid,
            :ppos => 1,
            :foo => "This is the valid answer test.",
            :questions => {
              "#{@quiz.quiz_phases[ 0 ].quiz_questions[ 0 ].id}" => "#{@quiz.quiz_phases[ 0 ].quiz_questions[ 0 ].quiz_answers[ 0 ].id}",
              "#{@quiz.quiz_phases[ 0 ].quiz_questions[ 1 ].id}" => "#{@quiz.quiz_phases[ 0 ].quiz_questions[ 1 ].quiz_answers[ 2 ].id}" ,
              "#{@quiz.quiz_phases[ 0 ].quiz_questions[ 2 ].id}" => "#{@quiz.quiz_phases[ 0 ].quiz_questions[ 2 ].quiz_answers[ 1 ].id}"
            }
          )
        end

        context "without user_id do " do 
          should "create valid user quiz answers without user" do
            assert_response 303
            assert_equal( 3, @instance.user_quiz_answers.size )
          end

          should "redirect to next phase if not last phase" do
            assert_response 303
            assert_redirected_to "/quizzes/open/#{@instance.quiz_instance_uuid}/2"
          end

        end
      end

      context "on POST to submit_answers last_phase" do
        setup do
          post(
            :submit_answers,
            :qiid => @instance.quiz_instance_uuid,
            :ppos => 3,
            :foo => "This is the valid answer test.",
            :questions => {
              "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 0 ].id}" => "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 0 ].quiz_answers[ 0 ].id}",
              "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 1 ].id}" => "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 1 ].quiz_answers[ 2 ].id}" ,
              "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 2 ].id}" => "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 2 ].quiz_answers[ 1 ].id}"
            }
          )
        end

        should "complete quiz if submitting to last phase" do
          assert_response 303
          assert_equal( true, @instance.completed? )
        end

        should "redirect to next location if last phase" do
          assert_redirected_to "/quizzes/completed/#{@instance.quiz_instance_uuid}"
        end
      end

      context "on POST to submit_answers with user_id" do
        #debugger
        setup do
          @u = Factory :user
          post(
            :submit_answers,
            :qiid => @instance.quiz_instance_uuid,
            :ppos => 3,
            :user_id => @u.id,
            :foo => "This is the valid answer test.",
            :questions => {
              "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 0 ].id}" => "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 0 ].quiz_answers[ 0 ].id}",
              "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 1 ].id}" => "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 1 ].quiz_answers[ 2 ].id}" ,
              "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 2 ].id}" => "#{@quiz.quiz_phases[ 2 ].quiz_questions[ 2 ].quiz_answers[ 1 ].id}"
            }
          )
        end

        should "create proper user quiz answers with user" do
          assert_equal( 3, User.find( @u.id ).user_quiz_answers.size )
        end
        
      end

    end
  end

end
