class Publishers::QuizLeadQuestionsController < ApplicationController
  before_filter :authorize_site_admin_access
  
  def create
    QuizLeadQuestion.create params[ :quiz_lead_question ]
    redirect_to "/publishers/quizzes"
  end

  def edit
    @quiz_lead_question = QuizLeadQuestion.find params[ :id ]
  end

  def index
    @quiz_lead_questions = QuizLeadQuestion.all :include => :quiz_lead_answers
  end

  def new
    @quiz_lead_question = QuizLeadQuestion.new :quiz_category_id => params[ :id ]
  end

  def update
    @quiz_lead_question = QuizLeadQuestion.find params[ :id ]
    @quiz_lead_question.update_attributes params[ :quiz_lead_question ]

    redirect_to "/publishers/quizzes"
  end
end
