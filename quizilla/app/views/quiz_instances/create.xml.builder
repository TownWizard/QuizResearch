require 'quiz_api_xml_helper'

helper = QuizApiXmlHelper
xml.quiz do
  xml.quiz_request_metadata do
    xml.completed @quiz_instance.completed
    #xml.quiz_id "3"
    #xml.quiz_instance_uuid "QUIZ_INSTANCE_IDENTIFIER"
    xml.global_category_identifier @quiz_phase.quiz.quiz_category.name
    #xml.partner_category_identifier @quiz_phase.quiz.quiz_category.name
    xml.post_answers_uri "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes#{@url_version_string}/open/#{@quiz_instance.quiz_instance_uuid}/#{@quiz_phase.position}"

    xml.total_quiz_phases @quiz_phase.quiz.quiz_phases.count
    xml.post_parameter do
      xml.name "quiz_page"
      xml.value @quiz_phase.position
    end
    xml.post_parameter do
      xml.name "qiid"
      xml.value "#{@quiz_instance.quiz_instance_uuid}"
    end
    #debugger
    @quiz.attributes.reject{ |e,f| helper.filter_my_attributes( e ) }.sort.each do |k,v|
      xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
    end
  end
  xml.quiz_phase do
    @quiz_phase.attributes.reject{ |e,f|  helper.filter_my_attributes( e, :quiz_phase ) }.sort.each do |k,v|
      xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
    end

    @quiz_phase.quiz_questions.each do |question|
      xml.quiz_question do
        question.attributes.reject{ |e,f|  helper.filter_my_attributes( e ) }.sort.each do |k,v|
          xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
        end

        question.quiz_answers.each do |answer|
          xml.answer_option do
            answer.attributes.reject{ |e,f| helper.filter_my_attributes( e ) }.sort.each do |k,v|
              xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
            end
            xml.answer_response_recommendation answer.quiz_learning_blurb.blurb
            xml.post_parameter do
              xml.type "radio"
              xml.name "questions[#{question.id}]"
              xml.value answer.id
            end
          end
        end # quiz_answer
      end # quiz_answers container
    end # quiz_questions loop
  end # phase
  xml.completed_quiz_result do

  end
#    @previous_quiz_answers.each do |pa|
#      xml.previous_user_answer :id => pa.quiz_answer_id do
#        xml.answer_response_text pa.quiz_answer.quiz_learning_blurb.blurb
#        xml.quiz_question_id pa.quiz_answer.quiz_question_id
#      end
#    end
end # quiz loop