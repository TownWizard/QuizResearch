#require 'quiz_api_xml_helper'
#helper = QuizApiXmlHelper
#xml.instruct! :xml, :version=>"1.0"
#xml.quiz :id => @quiz.id do
#  xml.global_category_identifier @quiz_phase.quiz.quiz_category.name
#  xml.partner_category_identifier @quiz.quiz_category.name
#  xml.post_answers_uri "http://www.maxwelldaily.com/quizzes/"
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
#                xml.name "questions[#{question.id}]"
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