class Publishers::QuizAnswersController < Publishers::BaseController
  #layout 'publishers'
  before_filter :authorize_site_admin_access
  
  def create
    @quiz_answer = QuizAnswer.create( params[ :quiz_answer ] )
    if @quiz_answer
      qlb = QuizLearningBlurb.new( params[ :quiz_learning_blurb ] )
      qlb.quiz_answer_id = @quiz_answer.id
      qlb.save
    end
    quiz_id = @quiz_answer.quiz_question.quiz_phase.quiz.id
    session[:quiz_div][quiz_id.to_s.to_sym][:questions_div][@quiz_answer.quiz_question.id.to_s.to_sym] = "Enabled"
      
    respond_to do |wants|
      wants.html { redirect_to "/publishers/quizzes/show/#{quiz_id}#answer-#{@quiz_answer.id}" and return }
    end
  end

  def destroy
    @quiz_answer = QuizAnswer.find params[ :id ]
    @quiz_id = @quiz_answer.quiz_question.quiz_phase.quiz.id

    @quiz_answer.destroy
    redirect_to "/publishers/quizzes/show/#{@quiz_id}" and return
    
  end
  
  def edit
    @quiz_answer = QuizAnswer.find params[ :id ]
    @quiz_learning_blurb = @quiz_answer.quiz_learning_blurb
  end
  
  def new
    @quiz_question = QuizQuestion.find(params[:quiz_question_id])
    @quiz_answer = @quiz_question.quiz_answers.new
    @quiz_learning_blurb = QuizLearningBlurb.new
    @default_position = QuizAnswer.maximum( :position, :conditions => [ 'quiz_question_id = ?', params[ :quiz_question_id ] ] ).to_i + 1
  end

  def update
    @quiz_answer = QuizAnswer.find params[ :id ]
    @quiz_answer.update_attributes( params[ :quiz_answer ] )
    @quiz_answer.quiz_learning_blurb.update_attributes( params[ :quiz_learning_blurb ] )
    quiz_id = @quiz_answer.quiz_question.quiz_phase.quiz.id
    respond_to do |wants|
      flash[ :notice ] = "You successfully updated your answer."
      wants.html { redirect_to "/publishers/quizzes/show/#{quiz_id}#answer-#{@quiz_answer.id}" and return }
    end
  end

end
