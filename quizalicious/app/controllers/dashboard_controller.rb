class DashboardController < ApplicationController
  
  def index
    current_facebook_user.fetch
    logger.info "hey"

    @quizzes = Quiz.all
    return
#  rescue Exception
#      top_redirect_to auth_url
  end

  def show
    current_facebook_user.fetch
  end
end
