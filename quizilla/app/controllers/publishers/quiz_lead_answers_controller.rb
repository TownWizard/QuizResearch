class Publishers::QuizLeadAnswersController < Publishers::BaseController
  before_filter :authorize_site_admin_access
  
  def create
    @quiz_lead_answer = QuizLeadAnswer.create( params[ :quiz_lead_answer ] )
    redirect_to "/publishers/quizzes"
  end

  def edit
    @quiz_lead_answer = QuizLeadAnswer.find params[ :id ]
    @quizzes = Quiz.find :all, :conditions => [ 'quiz_category_id = ?', @quiz_lead_answer.quiz_lead_question.quiz_category_id ]
  end

#  def index
#    @quiz_lead_questions = QuizLeadQuestion.all :include => :quiz_lead_answers
#  end

  def new
    @quiz_lead_answer = QuizLeadAnswer.new(
      :quiz_lead_question_id => params[ :quiz_lead_question_id ],
      :quiz_id => params[ :quiz_id ]
    )

    qlq = QuizLeadQuestion.find params[ :quiz_lead_question_id ]
    @quizzes = Quiz.find :all, :conditions => [ 'quiz_category_id = ?', qlq.quiz_category_id ]
    
  end

  def update
    @quiz_lead_answer = QuizLeadAnswer.find params[ :id ]
    @quiz_lead_answer.update_attributes params[ :quiz_lead_answer ]

    redirect_to "/publishers/quizzes"
  end
end
