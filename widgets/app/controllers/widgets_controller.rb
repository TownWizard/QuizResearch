class WidgetsController < ApplicationController

  def get_survey
    @widget = Widget.find params[:id]
    @quiz = @widget.quiz
    redirect_to "/quizzes/#{@quiz.id}/start?widget_id=#{@widget.id}"
  end
  
  def get_api_widget
    @widget = Widget.find(params[:id])
    render :layout => false
  end
end
