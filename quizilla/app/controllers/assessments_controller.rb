class AssessmentsController < ApplicationController

  before_filter :load_user
  before_filter :require_user
  
  def index
    # ok.  let's check all the cookies and make sure we get things assigned to the user.
    @quiz_instances = QuizInstance.find( :all,
        :conditions => [ 'quiz_instance_uuid IN ( ? )', qiid_cookie_read ] )
        
    @quiz_instances.concat( QuizInstance.find( :all, :conditions => [ 'quiz_instance_uuid = ?', cookies[ :lcqiid ] ] ) )

    @quiz_instances.each do |i|
      i.user_id = @user.id
      i.save
    end
    @user.reload
    # so, for now, we'll just list any completed assessments and let people check em out.
    @completed_quizzes = @user.quiz_instances.completed.concat( @quiz_instances.select { |qi| qi.completed == true } ).uniq
    @incomplete_quizzes = @user.quiz_instances.incomplete.concat( @quiz_instances.select { |qi| qi.completed == false } ).uniq
  end

  def show
    if params[ :qiid ]
      @quiz_instance = QuizInstance.find( :first, :conditions => [ 'quiz_instance_uuid = ?', params[ :qiid ] ] )
      qcat = @quiz_instance.quiz.quiz_category
      @quiz_description = qcat.name.to_s.downcase[0..qcat.name.to_s.index(" ").to_i - 1]

      @score = 0

      @quiz_instance.user_quiz_answers.each do |answer|
        @score += answer.quiz_answer.value
      end

      @quiz_recommendation = @quiz_instance.quiz.quiz_recommendations.for_score( @score )[ 0 ]
    end
  end

end
