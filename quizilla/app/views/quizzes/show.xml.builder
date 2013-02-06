require 'quiz_api_xml_helper'

helper = QuizApiXmlHelper
quiz = @quiz_phase.quiz
xml.instruct! :xml, :version=>"1.0"

xml.quiz do
  xml.quiz_request_metadata do
    #xml.completed @quiz_instance.completed
    #xml.quiz_id "3"
    #xml.quiz_instance_uuid "QUIZ_INSTANCE_IDENTIFIER"
    xml.global_category_identifier @quiz_phase.quiz.quiz_category.try(:name)
    #xml.partner_category_identifier @quiz_phase.quiz.quiz_category.name
    #xml.post_answers_uri "http://#{@partner_site.host}.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes/open/#{@quiz_instance.quiz_instance_uuid}/#{@quiz_phase.position}"
    #xml.user_id "42"
    xml.image_path @quiz_phase.quiz.quiz_photo_path
    xml.total_quiz_phases @quiz_phase.quiz.quiz_phases.count
    xml.post_parameter do
      xml.name "quiz_page"
      xml.value @quiz_phase.position
    end
#    xml.post_parameter do
#      xml.name "qiid"
#      xml.value "#{@quiz_instance.quiz_instance_uuid}"
#    end
    #debugger
    quiz.attributes.reject{ |e,f| helper.filter_my_attributes( e ) }.sort.each do |k,v|
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
            if @existing_quiz_answers && @existing_quiz_answers.detect { |cqa| cqa.quiz_answer_id == answer.id }
              xml.existing_answer true
            end
            xml.post_parameter do
              if (question.answer_display_type.display_type == 'TEXTAREA')
                xml.type 'hidden'
              else
                xml.type question.answer_display_type.display_type.downcase
              end
              xml.name "questions[#{question.id}]"
              xml.value answer.id
              if answer.answer_response_type.response_type.downcase == 'text' || answer.answer_response_type.response_type.downcase == 'textarea'
                xml.text_post_parameter_suboption do
                 xml.type answer.answer_response_type.response_type.downcase
                 xml.name "answer[#{answer.id}]"
                 xml.size answer.size
                 xml.maxlength answer.maxlength
                 xml.rows answer.rows
                 xml.cols answer.cols
                end
              end
            end
#            answer.attributes.reject{ |e,f| helper.filter_my_attributes( e ) }.sort.each do |k,v|
#              xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
#            end
          end
        end # quiz_answer
      end # quiz_answers container
    end # quiz_questions loop
  end # phase

end

#require 'quiz_api_xml_helper'
#helper = QuizApiXmlHelper
#xml.instruct! :xml, :version => "1.0"
#xml.quiz :id => @quiz.id do
#  xml.completed
#  xml.global_category_identifier @quiz_phase.quiz.quiz_category.name
#  xml.partner_category_identifier @quiz.quiz_category.name
#  xml.post_answers_uri "http://#{@partner_site.host}.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes/open/new"
#  #xml.post_answers_uri "http://www.maxwelldaily.com/quizzes/open/new"
#  xml.total_quiz_phases @quiz.quiz_phases.count
#
#  @quiz.attributes.reject{ |e,f| helper.filter_my_attributes( e ) }.sort.each do |k,v|
#      xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
#    end
#
#    xml.quiz_phase :id => @quiz_phase.id do
#      @quiz_phase.attributes.reject{ |e,f|  helper.filter_my_attributes( e, :quiz_phase ) }.sort.each do |k,v|
#        xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
#      end
#
#      @quiz_phase.quiz_questions.each do |question|
#        xml.quiz_question :id => question.id do
#          question.attributes.reject{ |e,f|  helper.filter_my_attributes( e ) }.sort.each do |k,v|
#            xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
#          end
#
#          question.quiz_answers.each do |answer|
#            xml.answer_option :id => answer.id do
#              xml.post_parameter do
#                xml.type "radio"
#                xml.name "lqa[#{question.id}]"
#                #xml.name "questions[#{question.id}]"
#                xml.value answer.id
#              end
#              answer.attributes.reject{ |e,f|  helper.filter_my_attributes( e ) }.sort.each do |k,v|
#                xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
#              end
#              # pull out the blurb
##              blurb = answer.quiz_learning_blurb
##              xml.answer_response :id => blurb.id do
##                blurb.attributes.reject{ |e,f|  helper.filter_my_attributes( e, :learning_blurb ) }.sort.each do |k,v|
##                  xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
##                end
##              end
#            end
#          end # quiz_answer
#        end # quiz_answers container
#      end # quiz_questions loop
#    end # phase
#end
