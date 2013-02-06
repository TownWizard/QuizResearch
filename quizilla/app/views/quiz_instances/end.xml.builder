require 'quiz_api_xml_helper'

helper = QuizApiXmlHelper
quiz = @quiz_phase.quiz
xml.instruct! :xml, :version=>"1.0"
xml.quiz :id => quiz.id do
  #xml.quiz_id "3"
  #xml.quiz_instance_uuid "QUIZ_INSTANCE_IDENTIFIER"
  xml.completed @quiz_instance.completed
  xml.global_category_identifier @quiz_phase.quiz.quiz_category.name
  #xml.partner_category_identifier @quiz_phase.quiz.quiz_category.name
  xml.post_answers_uri "http://www.maxwelldaily.com/quizzes/open/#{@qiid}"
  xml.previous_page_uri "http://www.maxwelldaily.com/quizzes/open/#{@qiid}/#{@quiz_page}"
  xml.quiz_results_uri "http://www.maxwelldaily.com/assessments/show/#{@qiid}"
  #xml.user_id "42"
  xml.total_quiz_phases @quiz_phase.quiz.quiz_phases.count
  
  xml.quiz_complete_text "Your quiz is complete.  You may now be prompted to 
  give us some information and proceed on to see your quiz results"
  @previous_quiz_answers.each do |pa|
    xml.previous_user_answer :id => pa.quiz_answer_id do
      xml.answer_response_text pa.quiz_answer.quiz_learning_blurb.blurb
      xml.quiz_question_id pa.quiz_answer.quiz_question_id
    end
  end
end
