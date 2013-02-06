class Publishers::QuizQuestionsController < Publishers::BaseController
  #layout 'publishers'
  before_filter :authorize_site_admin_access
  
  def create
    
    @quiz_question = QuizQuestion.create params[ :quiz_question ]
    quiz_id = @quiz_question.quiz_phase.quiz.id
    
    session[:quiz_div][quiz_id.to_s.to_sym][:phases_div][@quiz_question.quiz_phase.id.to_s.to_sym] = "Enabled"
    #publishers_redirect "phase-#{@quiz_question.quiz_phase.id}-question-#{@quiz_question.position}" and return
    redirect_to "/publishers/quizzes/#{quiz_id}?quiz_phases_list=enabled&quiz_questions_list=enabled#phase-#{@quiz_question.quiz_phase.id}-question-#{@quiz_question.position}"
  end
  
  def destroy
    quiz_id = QuizQuestion.find( params[ :id ]).quiz_phase.quiz.id
    QuizQuestion.destroy( params[ :id ] )
    flash[ :notice ] = "Question Deleted."
    redirect_to "/publishers/quizzes/#{quiz_id}" and return
  end

  def edit
    @quiz_question = QuizQuestion.find params[ :id ]
    @quiz_phases = @quiz_question.quiz_phase.quiz.quiz_phases
  end

  def new
    @quiz_question = QuizQuestion.new
    @default_position = QuizQuestion.maximum( :position, :conditions => [ "quiz_phase_id = ?", params[ :quiz_phase_id ] ] ).to_i
  end

  def update
    @quiz_question = QuizQuestion.find params[ :id ]
    @quiz_question.update_attributes( params[ :quiz_question ] )
    @quiz_question.reload
    # Reset +answer_response_type+ of quiz_answers of each question if set to +RADIO+ or +CHECKBOX+
    unless @quiz_question.answer_display_type.display_type.eql?("RADIO") || @quiz_question.answer_display_type.display_type.eql?("CHECKBOX")
      @quiz_question.quiz_answers.each {|answer| answer.update_attributes(:answer_response_type_id => AnswerResponseType.find_by_response_type("FIXED").id)}
    end
    quiz_id = @quiz_question.quiz_phase.quiz.id
    flash[ :notice ] = "You successfully updated this quiz question."
    redirect_to "/publishers/quizzes/#{quiz_id}?quiz_phases_list=enabled&quiz_questions_list=enabled#phase-#{@quiz_question.quiz_phase.id}-question-#{@quiz_question.position}"
  end

end
