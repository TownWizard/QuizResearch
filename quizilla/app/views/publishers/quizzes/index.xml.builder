xml.instruct! :xml, :version=>"1.0"
xml.quiz_data do
  @quizzes.each do |quiz|
    xml.quiz :id => quiz.id do
      quiz.attributes.sort.each do |k,v|
        xml.__send__ k, v
      end
      xml.quiz_phases do
        quiz.quiz_phases.each do |phase|
          xml.phase :id => phase.id do
            phase.attributes.sort.each do |k,v|
              xml.__send__ k, v
            end
            xml.quiz_questions do
              phase.quiz_questions.each do |question|
                xml.quiz_question :id => question.id do
                  question.attributes.sort.each do |k,v|
                    xml.__send__ k, v
                  end
                  xml.quiz_answers do
                    question.quiz_answers.each do |answer|
                      xml.quiz_answer :id => answer.id do
                        answer.attributes.sort.each do |k,v|
                          xml.__send__ k, v
                        end
                        # pull out the blurb
                        blurb = answer.quiz_learning_blurb
                        xml.learning_blurb :id => blurb.id do
                          blurb.attributes.sort.each do |k,v|
                            xml.__send__ k, v
                          end
                        end
                      end
                    end # quiz_answer
                  end # quiz_answer loop
                end # quiz_answers container
              end # quiz_questions loop
            end # quiz_questions
          end # phase
        end # quiz_phases loop
      end # phase_container
    end # quiz loop
  end #quiz container
end