
  class QuizApiXmlHelper

    # these attributesd are filtered by the generic "all attribute loops" we do
    # during xml build.  They may still be added manually.
    @@filtered_attributes =
      {
        :global => [
          'active', 'boost_keywords', 'created_at', 'id', 'quiz_category_id', 'quiz_phase_id',
          'quiz_photo_path', 'quiz_question_id', 'updated_at', 'value', 'quiz_answer_id', 'partner_id'
        ],
        :learning_blurb => [ 'name' ],
        :quiz_phase => [ 'name', 'quiz_id', 'branch_question_id' ],
        :previous_quiz_answer => [ 'user_id', 'quiz_instance_id' ]
      }
      
    def self.attribute_elements_map
      {
        'answer' => 'answer_option_text',
        'blurb' => 'blurb_text',
        'question' => 'question_text',
        'value' => 'answer_score',
        'blurb' => 'answer_response_text'
      }
    end

    def self.filter_my_attributes( attribute_name, custom = nil )

      if custom != nil
        if( @@filtered_attributes[ :global ].include?( attribute_name ) || (
              @@filtered_attributes[ custom ] &&
              @@filtered_attributes[ custom ].include?( attribute_name ) ) )
          true
        else
          false
        end
      else
        if( @@filtered_attributes[ :global ].include?( attribute_name ) )

          true
        else
          false
        end
      end
    end
    
  end
