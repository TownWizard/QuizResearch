require 'quiz_api_xml_helper'
#class <<xml
#
#  def attribute_elements_map
#    {
#      'answer' => 'answer_option_text',
#      'blurb' => 'blurb_text',
#      'question' => 'question_text',
#      'value' => 'answer_score',
#      'blurb' => 'answer_response_text'
#    }
#  end
#
#  def filtered_attributes
#    {
#      :global => [
#        'active', 'boost_keywords', 'created_at', 'id', 'quiz_category_id', 'quiz_phase_id',
#        'quiz_photo_path', 'quiz_question_id', 'updated_at', 'value', 'quiz_answer_id'
#      ],
#      :learning_blurb => [ 'name' ],
#      :quiz_phase => [ 'name', 'quiz_id' ]
#    }
#  end
#
#  def filter_my_attributes( attribute_name, custom = nil )
#    RAILS_DEFAULT_LOGGER.info "ATTRIBUTE: #{attribute_name}, KEY: #{custom}"
#
#
#    if custom != nil
#      if( filtered_attributes[ :global ].include?( attribute_name ) || ( filtered_attributes[ custom ] && filtered_attributes[ custom ].include?( attribute_name ) ) )
#        true
#      else
#        false
#      end
#    else
#      if( filtered_attributes[ :global ].include?( attribute_name ) )
#        true
#      else
#        false
#      end
#    end
#  end
#
#end
helper = QuizApiXmlHelper
quiz = @quiz_phase.quiz
xml.instruct! :xml, :version=>"1.0"

#xml.quiz_data do
  #debugger
  xml.quiz :id => quiz.id do
    #xml.quiz_id "3"
		#xml.quiz_instance_uuid "QUIZ_INSTANCE_IDENTIFIER"
    xml.global_category_identifier @quiz_phase.quiz.quiz_category.name
    #xml.partner_category_identifier @quiz_phase.quiz.quiz_category.name
    xml.post_answers_uri "http://www.maxwelldaily.com/quizzes/open/QUIZ_INSTANCE_IDENTIFIER"
    xml.previous_page_uri "http://www.maxwelldaily.com/quizzes/open/QUIZ_INSTANCE_IDENTIFIER/POSITION"
		#xml.user_id "42"
    xml.total_quiz_phases @quiz_phase.quiz.quiz_phases.count
    xml.post_parameter do
      xml.name "quiz_page"
      xml.value @quiz_phase.position
    end
    xml.post_parameter do
      xml.name "qiid"
      xml.value "QUIZ_INSTANCE_IDENTIFIER"
    end
    #debugger
    quiz.attributes.reject{ |e,f| helper.filter_my_attributes( e ) }.sort.each do |k,v|
      xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
    end

    xml.quiz_phase :id => @quiz_phase.id do
      @quiz_phase.attributes.reject{ |e,f|  helper.filter_my_attributes( e, :quiz_phase ) }.sort.each do |k,v|
        xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
      end

      @quiz_phase.quiz_questions.each do |question|
        xml.quiz_question :id => question.id do
          question.attributes.reject{ |e,f|  helper.filter_my_attributes( e ) }.sort.each do |k,v|
            xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
          end

          question.quiz_answers.each do |answer|
            xml.answer_option :id => answer.id do
              xml.post_parameter do
                xml.type "radio"
                xml.name "questions[#{question.id}]"
                xml.value answer.id
              end
              answer.attributes.reject{ |e,f|  helper.filter_my_attributes( e ) }.sort.each do |k,v|
                xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
              end
              # pull out the blurb
#              blurb = answer.quiz_learning_blurb
#              xml.answer_response :id => blurb.id do
#                blurb.attributes.reject{ |e,f|  helper.filter_my_attributes( e, :learning_blurb ) }.sort.each do |k,v|
#                  xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
#                end
#              end
            end
          end # quiz_answer
        end # quiz_answers container
      end # quiz_questions loop
    end # phase
  end # quiz loop
#end
