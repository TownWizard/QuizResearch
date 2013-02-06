require 'quiz_api_xml_helper'

helper = QuizApiXmlHelper

xml.instruct! :xml, :version=>"1.0"
quiz_id = nil
if @quiz_instance
  quiz = @quiz_phase.quiz
  quiz_id = quiz.id
end

#xml.quiz do
#  if @quiz_instance
#
#    xml.completed @quiz_instance.completed
#
#    xml.global_category_identifier @quiz_phase.quiz.quiz_category.name
#    #xml.partner_category_identifier @quiz_phase.quiz.quiz_category.name
#    xml.post_answers_uri "http://#{@partner_site.host}.#{@partner_site.domain}#{ENV[ 'qport' ]}/quizzes/open/#{@qiid}/#{@quiz_phase.position}"
#
#    xml.total_quiz_phases @quiz_phase.quiz.quiz_phases.count
#
#    xml.post_parameter do
#      xml.name "quiz_page"
#      xml.value @quiz_phase.position
#    end
#    xml.post_parameter do
#      xml.name "qiid"
#      xml.value "#{@quiz_instance.quiz_instance_uuid}"
#    end
#  end
  xml.errors do
    @errors.each_pair do |name,msg|
      #xml.__send__( name ) do
      xml.error do
        xml.field name
        xml.message msg[ 0 ]
        xml.code( msg[ 1 ] )
      end
    end
  end
#end