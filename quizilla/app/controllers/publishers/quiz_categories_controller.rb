class Publishers::QuizCategoriesController < Publishers::BaseController
  layout 'publishers'
  before_filter :authorize_site_admin_access

  def edit
    @quiz_category = QuizCategory.find params[ :id ]
  end

  def index
    @quiz_categories = QuizCategory.all
  end

  def new
    @quiz_category = QuizCategory.new
  end
  
  def create
    @quiz_category = QuizCategory.create( params[ :quiz_category ] )
    @quiz_category.active = 1
    @quiz_category.save
    flash[ :notice ] = "Quiz Category Created Successfully."
    redirect_to "/publishers/quiz_categories" and return
  end

  def show
    @quiz_category = QuizCategory.find params[ :id ]
    #@quiz_lead_questions = @quiz_category.quiz_lead_questions
  end

   def update
    @quiz_category = QuizCategory.find params[ :id ]
    @quiz_category.update_attributes params[ :quiz_category ]
    flash[ :notice ] = "Quiz Category Updated Successfully."
    redirect_to "/publishers/quiz_categories" and return
  end

end
