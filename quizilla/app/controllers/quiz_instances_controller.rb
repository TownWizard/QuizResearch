class QuizInstancesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  #before_filter :authenticate_request, :load_user, :expose_authenticity_token
  before_filter :load_user, :expose_authenticity_token, :set_version_string

  @@uuid_generator = UUID.new
  
  #change in semantics here, so we need to make sure we insert the opening question now.
  def create
    #@errors = {}
    if params[ :quiz_id ] && params[ :user_id ]
#      lead_answer_id = params[ :lqa ]
#      if lead_answer_id.blank? && !params[ :questions ].blank?
#        params[ :questions ].each_pair do |qid,aid|
#          if QuizQuestion.find_by_id( qid ).quiz_phase.position == 0
#            lead_answer_id = aid
#          end
#        end
#      end
      
      @quiz_instance = QuizInstance.create(
          :quiz_id => params[ :quiz_id ],
          :user_id => nil,
          :quiz_instance_uuid => @@uuid_generator.generate( :compact ),
          :lead_answer_id => nil,
          :partner_user_id => params[ :user_id ]
      )

      if !params[ :questions ].blank?
        params[ :questions ].each_pair do |qid,aid_list|
          aid_list.split( ',' ).each do |aid|
            answer_text=''
            answer_text = params[ :answer ][aid.to_s] unless params[ :answer ].blank? || params[ :answer ][aid.to_s].blank?
            UserQuizAnswer.create( :quiz_answer_id => aid, :user_id => ( @user ? @user.id : nil ), :quiz_instance_id => @quiz_instance.id, :user_answer_text_response => answer_text )
          end
        end
      end

      qiid_cookie_write @quiz_instance.quiz_instance_uuid

      if @quiz_instance
        # no more POST / Redirect, so we have to revert to this sort of mess.
        # now we need to set up all the data we'll need to render the first
        # phase of the quiz.
        previous_quiz_phase = QuizPhase.first(:conditions => ['quiz_id = ? and position = 0', @quiz_instance.quiz_id])
        begin
          if params[:lqa]
            next_phase_id = QuizAnswer.find(params[:lqa]).next_quiz_phase_id
          else
            next_phase_id = QuizAnswer.find(params[:questions][previous_quiz_phase.branch_question_id.to_s]).next_quiz_phase_id
          end
          @quiz_phase = QuizPhase.find(next_phase_id)
        rescue
          @quiz_phase = QuizPhase.first(:conditions => ['quiz_id = ? and position = 1', @quiz_instance.quiz_id])
        end
        @quiz = @quiz_instance.quiz
        @quiz_page = 1

        # also build the resume URI if we have previous instances of this
        # quiz from this user.  resume URI is based on the LAST instanced
        # opened.
        load_previous_quiz_instance

        @total_quiz_questions = QuizQuestion.count(
          :conditions => [ 'quizzes.id = ? and quiz_questions.active = 1', @quiz.id ],
          :joins => { :quiz_phase => :quiz }
        )

        render :file => 'quiz_instances/show.xml'

      else
        @errors[ 'quiz' ] = [
          'Internal Service Error.  Unable to create quiz instance.',
          #'We are unable to start your quiz at this time.',
          500 ]

      end
    else
      if !params[ :quiz_id ]
        @errors[ 'quiz_id' ] = [
          'Required parameter Quiz ID not provided',
          #'Please select a quiz to continue.',
          400 ]
      end

      if !params[ :user_id ]
        @errors[ 'user_id' ] = [
          'Required parameter User ID not provided.',
          #'Please select a quiz to continue.',
          400 ]
      end
      #render :text => "You must supply a quiz id in order to create an open quiz instance.", :status => 400
    end

    if @errors.size != 0
      #if params[ :format ] = 'xml'
        render 'errors.xml.builder'#, :status => @error_code
      #end
    end
  end

  def index
    if params[ :user_id ]
      @quiz_instances = QuizInstance.find( :all, :conditions => [ 'user_id = ?', params[ :user_id ] ] )
    else
      render :text => "You must supply a user id to request a list of open instances", :status => 400
    end
  end

  # in Old World, supplies:
  #   @quiz,
  #   @quiz_instance,
  #   @qla, @previous_answers,
  #   @prev_ans ( boolean )
  def show
    @quiz_instance = QuizInstance.find( :first,
      :conditions => [ 'quiz_instance_uuid = ?', params[ :qiid ] ] )
      #:include => { :quiz => { [ :quiz_phases => { :conditions => [ 'position = ?', @quiz_page ] } ] => { :quiz_questions => { :quiz_answers => :user_quiz_answers } } } } )

    @qiid = params[ :qiid ]
    @quiz = @quiz_instance.quiz
    if params[ :ppos ] == 'end'
      @quiz_page = @quiz.quiz_phases.last.position
      @quiz_phase = @quiz.quiz_phases.last
    else
      if params[ :ppos ]
        @quiz_page = params[ :ppos ]
      else
        # if no position is supplied, we'll want to leave them at the step AFTER the one they left off on.
        if @quiz_instance.user_quiz_answers.size > 0
          last_phase_position = UserQuizAnswer.all(
            :conditions => [ 'quiz_instance_id = ?', @quiz_instance.id ],
            :include => { :quiz_answer => { :quiz_question => :quiz_phase } }
          ).sort {
            |a,b| a.quiz_answer.quiz_question.quiz_phase.position <=> b.quiz_answer.quiz_question.quiz_phase.position
          }.reverse[ 0 ].quiz_answer.quiz_question.quiz_phase.position
         
         @quiz_page = last_phase_position
        else
          @quiz_page = 1
        end
      end

      @quiz_phase = QuizPhase.find(
        :first,
        :conditions => [ 'quiz_id = ? AND position = ?', @quiz.id, @quiz_page ],
        :include => { :quiz_questions => :quiz_answers } )
      end
    
    if @quiz_page
      @existing_quiz_answers =
        UserQuizAnswer.all(
          :conditions => "quiz_instance_id = #{@quiz_instance.id} AND
            quiz_phases.position = #{@quiz_phase.position}",
          :joins => { :quiz_answer => { :quiz_question => [ :quiz_phase ] } },
          :include => { :quiz_answer => :quiz_learning_blurb } )
    end

    if @quiz_phase.position == 1
      load_previous_quiz_instance
    end

    @total_quiz_questions = QuizQuestion.count(
      :conditions => [ 'quizzes.id = ? and quiz_questions.active = 1', @quiz.id ],
      :joins => { :quiz_phase => :quiz }
    )

    if params[ :format ] == 'html'
      render :file => 'quiz_instances/show', :layout => 'af-entertainment'
    else
      render :file => 'quiz_instances/show.xml'
    end
    
  end

  def submit_answers
    
    @quiz_page = ( params[ :ppos ] ? params[ :ppos ] : 1 ).to_i
    @quiz_instance = QuizInstance.find( :first, :conditions => [ 'quiz_instance_uuid = ?', params[ :qiid ] ], :include => :quiz )
    @quiz = @quiz_instance.quiz
    @quiz_phase = QuizPhase.find( :first, :conditions => [ 'quiz_id = ? AND position = ?', @quiz.id, @quiz_page ] )
    
    # great big validation block.  we can move this out later.
    # make sure we have all the necessary paramaters.
    # make sure we have enough submitted questions
    # make sure we have the correct questions for this phase.
    # make sure we have a valid answer for each question

    if params[ :qiid ] && params[ :ppos ] && params[ :questions ]
      #phase_questions = @quiz_instance.quiz.@quiz_phases[ params[ :ppos ].to_i - 1 ].quiz_questions
      phase_questions = @quiz_phase.quiz_questions
      questions_to_delete = []
      params[:questions].each_pair do |qid, aid_list|
        valid = true
        question = QuizQuestion.find(qid)
        if !question.skip_allowed && question.free_text_display_type?
          aid_list.each {|aid| valid = false if params[:answer][aid.to_sym].blank?}
        end
        questions_to_delete << qid unless valid
      end
      questions_to_delete.each {|qid| params[:questions].delete(qid)}
      
      #debugger
      if( params[ :questions ].size == phase_questions.size )
        # now we make sure that the questions actually correspond to this quiz phase.
        unless params[ :questions ].keys.map{ |k| k.to_i }.sort == phase_questions.collect{ | pq| pq.id }.sort
          @errors[ 'questions' ] = [
            'Submitted questions do not match questions for submitted quiz phase.', 
            #'Submitted questions do not match questions for submitted quiz phase.',
            400]
          #render :text => "Incorrect questions submitted for this quiz page", :status => 400 and return
        end
        
        valid_answers = true
        # then we make sure the answers correspond to this question.
        #params[ :questions ].values.each do |v|
        phase_questions.each do |q|
          params[ :questions ][ q.id.to_s ].split( ',' ).each do |a|
            unless q.quiz_answers.collect{ |qa| qa.id }.include?(a.to_i)
              valid_answers = false
            end
          end
        end
        #end

        if valid_answers == false
          @errors[ 'answers' ] = [
            'Incorrect answers submitted for one or more questions.',
            #'Incorrect answers submitted for one or more questions.',
            400]
          #render :text => "Incorrect answers submitted for one or more questions.", :status => 400 and return
        end

      else
        
        if !check_required_questions(params[:questions ], phase_questions)
        @errors[ 'answers' ] = [
          'Not enough submitted answers.  Answers for all questions in phase are required.',
          #'Please answer each question to continue to the next step.',
          400]
        #render :text => "Not enough submitted answers", :status => 400 and return
        end
      end
    else
      #params[ :qiid ] && params[ :ppos ] && params[ :questions ]
      if !params[ :qiid ]

        @errors[ 'qiid' ] = [
          "Required parameter qiid not supplied.  Please include all supplied Post Parameters.",
          #'Please answer all of the questions to continue',
          400]

      end

      if !params[ :ppos ]

        @errors[ 'ppos' ] = [
          "Required parameter ppos not supplied.  Please include all supplied Post Parameters.",
          #'Please answer all of the questions to continue',
          400 ]

      end

      if !params[ :questions ]

        @errors[ 'questions' ] = [
          "No question / answer values submitted for this phase",
          #'Please answer all of the questions to continue',
          400 ]

      end
      #render :text => "Incomplete.", :status => 400 and return

    end # end validation
   
    if @errors.size == 0
      # now we process the answers
      # lets load up any previous submitted answers for this instance and page
      current_answers =
        UserQuizAnswer.all(
          :conditions => "quiz_instance_id = #{@quiz_instance.id} AND
            quiz_phases.position = #{@quiz_phase.position}",
          :joins => { :quiz_answer => { :quiz_question => [ :quiz_phase ] } },
          :include => { :quiz_answer => :quiz_learning_blurb } )

      unless current_answers.size == 0
        UserQuizAnswer.delete(current_answers.collect{ |a| a.id })
      end

      params[ :questions ].each_pair do |qid,aid_list|
        aid_list.split( ',' ).each do |aid|
          answer_text=''
          answer_text = params[ :answer ][aid.to_s] unless params[ :answer ].blank? || params[ :answer ][aid.to_s].blank?
          UserQuizAnswer.create( :quiz_answer_id => aid, :user_id => ( @user ? @user.id : nil ), :quiz_instance_id => @quiz_instance.id, :user_answer_text_response => answer_text )
        end       
      end

      @total_quiz_questions = QuizQuestion.count(
        :conditions => [ 'quizzes.id = ? and quiz_questions.active = 1', @quiz.id ],
        :joins => { :quiz_phase => :quiz }
      )

      # if we are on the last phase, check to see if this quiz instance has been completed
      # if so, redirect to "assessment"
      # otherwise, bounce them over the next page.

      #current_phase = @quiz_instance.quiz.quiz_phases.ordered[ @quiz_page - 1 ]

      if @quiz_phase.last?
        @quiz_instance.completed = true
        @quiz_instance.save

        if params[ :format ] == 'xml'
          redirect_to "/quizzes#{ @url_version_string }/open/#{@quiz_instance.quiz_instance_uuid}/end/?format=xml", :status => 303 and return
        else
          redirect_to "/quizzes#{ @url_version_string }/open/#{@quiz_instance.quiz_instance_uuid}/end", :status => 303 and return
        end

      else
        unless @quiz_phase.branch_question.nil?
          begin
            next_phase_id = QuizAnswer.find(params[:questions][@quiz_phase.branch_question_id.to_s]).next_quiz_phase_id
            @quiz_phase = QuizPhase.find(next_phase_id)
          rescue
            @quiz_phase = @quiz_phase.lower_item
          end
        else
          @quiz_phase = @quiz_phase.lower_item
        end
        @quiz = @quiz_instance.quiz

        # also load up the answers we just created.
        @existing_quiz_answers =
        UserQuizAnswer.all(
          :conditions => "quiz_instance_id = #{@quiz_instance.id} AND
            quiz_phases.position = #{@quiz_phase.position}",
          :joins => { :quiz_answer => { :quiz_question => [ :quiz_phase ] } },
          :include => { :quiz_answer => :quiz_learning_blurb } )
        
        render :file => 'quiz_instances/show.xml'
#        unless params[ :format ] == 'xml'
#          redirect_to "/quizzes/open/#{@quiz_instance.quiz_instance_uuid}/#{@quiz_phase.next_phase.position}", :status => 303 and return
#        end
  #      if params[ :format ] == 'xml'
  #        redirect_to "/quizzes/open/#{@quiz_instance.quiz_instance_uuid}/#{@quiz_phase.next_phase.position}?format=xml", :status => 303 and return
  #      else
  #        redirect_to "/quizzes/open/#{@quiz_instance.quiz_instance_uuid}/#{@quiz_phase.next_phase.position}", :status => 303 and return
  #      end
      end
    else
  
      render 'errors.xml.builder'
    end
  end

  private
  def load_previous_quiz_instance
    @pqi = QuizInstance.first(
      :conditions => [
        'partner_user_id = ? and quiz_id = ? and completed = ?',
        params[ :user_id ],
        params[ :quiz_id ],
        false],
      :joins => :quiz,
      :order => 'created_at DESC',
      :limit => 1,
      :offset => 1
    )

    if @pqi && @pqi.user_quiz_answers.size > 0
      pqi_position = UserQuizAnswer.all(
          :conditions => [ 'quiz_instance_id = ?', @pqi.id ],
          :include => { :quiz_answer => { :quiz_question => :quiz_phase } }
        ).sort {
          |a,b| a.quiz_answer.quiz_question.quiz_phase.position <=> b.quiz_answer.quiz_question.quiz_phase.position
        }.reverse[ 0 ].quiz_answer.quiz_question.quiz_phase.position

      @pqi_position = pqi_position + 1

    else
      nil
    end
  end

  def check_required_questions(params, total_questions)
    questions = []
    params.each do |q|
      questions << QuizQuestion.find(q[0])
    end
    required = total_questions - questions
    required.each do |r|
      if !r.skip_allowed?
        return false
      end
    end
    true
  end
end
