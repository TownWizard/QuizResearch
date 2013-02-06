require 'quiz_api_xml_helper'

helper = QuizApiXmlHelper
quiz = @quiz_phase.quiz
xml.instruct! :xml, :version=>"1.0"

@free_text_answers = Hash.new
unless params[ :submitted_answers ].blank?
  @existing_quiz_answers = params[ :submitted_answers ].split( ',' )
  params[ :free_text_answers ].split(',').each do |arr|
    @free_text_answers.merge!({arr.split('=')[0] => arr.split('=')[1]})
  end
end
xml.quiz_request do
  unless @quiz_instance.completed
    xml.quiz_request_metadata do
      #xml.category_identifier @quiz_phase.quiz.quiz_category.name
      xml.completed @quiz_instance.completed
      xml.quiz_instance_uuid "#{@quiz_instance.quiz_instance_uuid}"
      xml.quiz_response_uri "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes#{@url_version_string}/open/#{@quiz_instance.quiz_instance_uuid}/#{@quiz_phase.position}"
      if @quiz_phase.position == 1 && @pqi && @pqi.user_quiz_answers && @pqi.user_quiz_answers.size > 0
        xml.resume_quiz_uri "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes#{@url_version_string}/open/#{@pqi.quiz_instance_uuid}/#{@pqi_position}"
      end
      xml.image_path quiz.quiz_photo_path
      xml.total_quiz_phases @quiz_phase.quiz.quiz_phases.count
      xml.total_quiz_questions @total_quiz_questions
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
              if @existing_quiz_answers && @existing_quiz_answers.detect { |cqa| cqa == answer.id.to_s }
                xml.existing_answer true
              end
              xml.post_parameter do
                xml.name "questions[#{question.id}]"
                xml.value answer.id
                if (question.answer_display_type.display_type == 'TEXTAREA' || question.answer_display_type.display_type == 'TEXT')
                  xml.type 'hidden'
                  xml.text_post_parameter_suboption do
                    xml.type question.answer_display_type.display_type.downcase
                    xml.name "answer[#{answer.id}]"
                    xml.size answer.size
                    xml.maxlength answer.maxlength
                    xml.rows answer.rows
                    xml.cols answer.cols
                  end
                else
                  xml.type question.answer_display_type.display_type.downcase
                  if answer.answer_response_type.response_type.downcase == 'text' || answer.answer_response_type.response_type.downcase == 'textarea'
                    xml.text_post_parameter_suboption do
                      xml.type answer.answer_response_type.response_type.downcase
                      xml.name "answer[#{answer.id}]"
                      xml.size answer.size
                      xml.maxlength answer.maxlength
                      xml.rows answer.rows
                      xml.cols answer.cols
#                      raise @free_text_answers.inspect
                      unless @free_text_answers[answer.id.to_s].nil?
                        xml.free_text_answer @free_text_answers[answer.id.to_s]
                      end
                    end
                  end
                 
                end
              end
              #               xml.post_parameter do
              #                xml.type "radio"
              #                xml.name "questions[#{question.id}]"
              #               xml.value answer.id
              #              end
              #            answer.attributes.reject{ |e,f| helper.filter_my_attributes( e ) }.sort.each do |k,v|
              #              xml.__send__( ( helper.attribute_elements_map[ k ] ? helper.attribute_elements_map[ k ] : k ), v )
              #            end
            end
          end # quiz_answer
        end # quiz_answers container
      end # quiz_questions loop
      
      unless params[:errors].blank?
        xml.errors do
          params[:errors].each do |msg|
            #xml.__send__( name ) do
            xml.error do
              xml.message msg             
            end
          end
        end
      end
    end # phase
  end

  if @quiz_instance.completed
    @score = 0
    @quiz_instance.user_quiz_answers.each do |answer|
      @score += answer.quiz_answer.try(:value).to_i
    end

    RAILS_DEFAULT_LOGGER.info "getting rec for score: #{@score}"
    @quiz_recommendation = @quiz_instance.quiz.quiz_recommendations.for_score( @score )[ 0 ]

    xml.completed_quiz_result do
      xml.name @quiz_instance.quiz.name
      xml.value @quiz_instance.quiz.id
      xml.description @quiz_instance.quiz.description
      xml.image_path @quiz_instance.quiz.quiz_photo_path
      xml.score @score
      xml.quiz_recommendation_title @quiz_recommendation.try(:name)
      xml.overall_recommendation_text @quiz_recommendation.try(:recommendation)
      @quiz_instance.user_quiz_answers.sort { |a,b| a.quiz_answer.position <=> b.quiz_answer.position }.each do |response|
        xml.quiz_response do
          xml.question_text response.quiz_answer.quiz_question.question
          if response.quiz_answer.quiz_question.free_text_display_type?
            xml.answer_response_text response.user_answer_text_response
          else
            if response.quiz_answer.answer_response_type_id.eql?(1)
              xml.answer_response_text response.quiz_answer.answer
            else
              xml.answer_response_text response.user_answer_text_response
            end
          end
          xml.answer_response_score response.quiz_answer.value
        end 
      end
    end
  end
end
