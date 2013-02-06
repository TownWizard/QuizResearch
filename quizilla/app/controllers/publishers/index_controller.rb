class Publishers::IndexController < Publishers::BaseController

  before_filter :authorize_publisher_basic_access

  layout 'publishers'
  
  def index
    if ((current_user.has_role? "admin") || (current_user.has_role? "partner_admin"))
      redirect_to "/publishers/quizzes" and return
    else
      redirect_to "/publishers/reports/surveys_report" and return
    end
      
  end

end
