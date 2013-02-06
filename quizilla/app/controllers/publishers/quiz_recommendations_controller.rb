class Publishers::QuizRecommendationsController < Publishers::BaseController
  #layout 'publishers'
  before_filter :authorize_site_admin_access
  
  def create
    
    qr = QuizRecommendation.create params[ :quiz_recommendation ]
    
    quiz_id = qr.quiz_id
    flash[ :notice ] = "You successfully added a recommendation to this quiz."
    redirect_to "/publishers/quizzes/show/#{quiz_id}#recommendation-#{qr.id}" and return
  end

  def edit
    @quiz_recommendation = QuizRecommendation.find params[ :id ]
  end

  def new
    @quiz_recommendation = QuizRecommendation.new
  end

  def update
    @quiz_recommendation = QuizRecommendation.find params[ :id ]
    @quiz_recommendation.update_attributes params[ :quiz_recommendation ]
    quiz_id = @quiz_recommendation.quiz.id
    
    flash[ :notice ] = "You successfully updated your answer."
    redirect_to "/publishers/quizzes/show/#{quiz_id}#recommendation-#{@quiz_recommendation.id}" and return
  end

end
