xml.instruct! :xml, :version => "1.0"
xml.quizzes do
  @quizzes.each do |quiz|
    xml.quiz_detail do
      xml.quiz_metadata do
        
        xml.category_identifier quiz.quiz_category.try(:name)

        xml.description quiz.description
        
        #if @quiz.start_date_time
        xml.start_date_time
        #end

	xml.image_path quiz.quiz_photo_path

        #if @quiz.end_date_time
        xml.end_date_time
        #end

        xml.start_quiz_uri "http://#{@partner_site.host}.quizilla.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes#{@url_version_string}/open/new"

        xml.title quiz.name

        xml.total_quiz_phases quiz.quiz_phases.size

        xml.total_quiz_questions quiz[ :total_quiz_questions ]

        xml.post_parameter do
          xml.type "hidden"
          xml.name "quiz_id"
          xml.value quiz.id
        end
      end
      if quiz.lead_phase
        current_quiz_lead_question = quiz.lead_phase.quiz_questions.first
        xml.lead_question do
          xml.quiz_question do
            xml.question_text current_quiz_lead_question.question
            current_quiz_lead_question.quiz_answers.each do |answer|
              xml.answer_option do
                xml.answer_option_text answer.answer
                xml.position answer.position
                xml.post_parameter do
                  xml.type "radio"
                  xml.name "lqa"
                  xml.value answer.id
                end
              end
            end
          end # end quiz question
        end
      end # end lead question
    end
  end
  #xml.debug @partner_site.inspect
end
